class CompanyService
  class CompanyCreationValidationError < StandardError; end

  class CompanyUpdateValidationError < StandardError; end

  class CompanyDeletionValidationError < StandardError; end

  MAX_COMPANIES_PER_SIDE = 2.freeze

  MIN_POP_PER_PLATOON = 7.freeze
  MAX_POP_PER_PLATOON = 25.freeze

  WAR_RULESET = "war".freeze

  def initialize(player)
    @player = player
  end

  def create_company(doctrine, name)
    unless can_create_company(doctrine)
      raise CompanyCreationValidationError.new("Player #{@player.id} has too many #{doctrine.faction.side} companies, cannot create another one.")
    end

    # Get ruleset
    ruleset = Ruleset.find_by(name: WAR_RULESET)

    # Create Company entity
    new_company = Company.create!(name: name,
                                  player: @player,
                                  doctrine: doctrine,
                                  faction: doctrine.faction,
                                  vps_earned: 0,
                                  man: ruleset.starting_man,
                                  mun: ruleset.starting_mun,
                                  fuel: ruleset.starting_fuel,
                                  pop: 0,
                                  ruleset: ruleset
    )

    # Create AvailableUnits for Company
    available_units_service = AvailableUnitsService.new(new_company)
    available_units_service.build_new_company_available_units

    new_company
  end

  # Takes the set of squads, validates that the company can upsert all of the squads, and persists them, overwriting old
  # squads as necessary. If an existing Squad is not in the new list of squads, it will be destroyed.
  #
  # Validates:
  # * The company belongs to the player, or an override is used
  # * The set of squad ids represent Squads belonging to the company
  # * The set of unit ids given in squads contain valid Unit ids
  # * The set of unit ids given in squads are a subset of the company's AvailableUnit unit ids
  # * The company has sufficient manpower, munitions, and fuel resources to afford all given squads
  # * Each platoon of squads (squads grouped by tab and index) has pop between the MIN and MAX allowed
  # * The company has sufficient availability in AvailableUnits for every unique unit in the given squads
  def update_company_squads(company, squads, override = false)
    unless can_update_company(company, override)
      # Raise validation error if the company does not belong to the player
      raise CompanyUpdateValidationError.new("Player #{@player.id} cannot delete Company #{company.id}")
    end

    existing_squads = company.squads
    existing_squad_ids = existing_squads.pluck(:id)
    payload_squad_ids = squads.select { |s| s[:squad_id].present? }.pluck(:squad_id)
    unless (payload_squad_ids - existing_squad_ids).size == 0
      raise CompanyUpdateValidationError.new("Invalid squad update. Given squad ids #{payload_squad_ids - existing_squad_ids}"\
        " that don't exist for the company #{company.id}")
    end

    ## Price every squad, sum up and validate against ruleset totals
    ## Raise validation error if insufficient

    # Get unique squad units
    uniq_unit_ids_new = get_uniq_squad_ids(squads)
    uniq_units_new_by_id = get_uniq_units_by_id(uniq_unit_ids_new)
    unless uniq_unit_ids_new.size == uniq_units_new_by_id.size
      # Raise validation error if some of the given unit ids for the new squads don't match a Unit record
      raise CompanyUpdateValidationError.new("Cannot create squads. Invalid unit id(s) given: #{uniq_unit_ids_new - uniq_units_new_by_id.keys}")
    end

    # Get available units for the company - cost is stored there
    # NOTE: Not handling free units for now, likely will need a flag on AvailableUnit
    available_units = company.available_units
    uniq_available_unit_ids = available_units.pluck(:unit_id).uniq
    if (uniq_unit_ids_new - uniq_available_unit_ids).size > 0
      # Raise validation error if some of the given unit ids are not in the set of AvailableUnits for the company
      raise CompanyUpdateValidationError.new("Cannot create squads, found unavailable unit ids #{uniq_unit_ids_new - uniq_available_unit_ids}")
    end

    # For now, expect unit id and company id are a unique constraint for AvailableUnits so using simple index_by,
    # but may change in the future to support free units
    available_units_by_unit_id = available_units.index_by(&:unit_id)

    # Build hash of tab and index to pop
    # Raise validation error if a platoon (squads within a tab and index) has either less pop than the minimum or
    # more pop than the maximum allowed
    tab_categories = Squad.tab_categories
    platoon_pop_by_tab_and_index = Hash[
      tab_categories[:core], Array.new(8,0),
      tab_categories[:assault], Array.new(8,0),
      tab_categories[:infantry], Array.new(8,0),
      tab_categories[:armour], Array.new(8,0),
      tab_categories[:anti_armour], Array.new(8,0),
      tab_categories[:support], Array.new(8,0),
    ]

    # TODO include upgrade prices
    # TODO include resource bonuses
    man_new = 0
    mun_new = 0
    fuel_new = 0
    pop_new = 0

    squads.each do |squad|
      available_unit = available_units_by_unit_id[squad[:unit_id]]
      man_new += available_unit.man
      mun_new += available_unit.mun
      fuel_new += available_unit.fuel
      platoon_pop_by_tab_and_index[squad[:tab]][squad[:index]] += available_unit.pop
      pop_new += available_unit.pop
    end

    ruleset = company.ruleset
    available_man, available_mun, available_fuel = get_total_available_resources(ruleset)
    man_remaining = available_man - man_new
    mun_remaining = available_mun - mun_new
    fuel_remaining = available_fuel - fuel_new

    unless man_remaining >= 0 && mun_remaining >= 0 && fuel_remaining >= 0
      # Raise validation error if the new squads' cost is greater in one or more resource than the ruleset's starting resources
      raise CompanyUpdateValidationError.new("Invalid squad update, negative resource balance found: #{man_remaining} manpower"\
        ", #{mun_remaining} munitions, #{fuel_remaining} fuel")
    end

    platoon_pop_by_tab_and_index.each do |tab, indices|
      indices.each_with_index do |pop, index|
        unless pop == 0 || (MIN_POP_PER_PLATOON <= pop && pop <= MAX_POP_PER_PLATOON)
          # Raise validation error if the platoon's aggregated pop is not between the min and max allowed pop per platoon
          raise CompanyUpdateValidationError.new("Invalid squad update. Platoon at [#{tab} #{index}] has #{pop} pop, "\
            "must be between [#{MIN_POP_PER_PLATOON},#{MAX_POP_PER_PLATOON}] inclusive")
        end
      end
    end

    ## Get all existing squads for the company
    existing_squads_by_unit_id = existing_squads.group_by(&:unit_id)

    # Get payload squads by unit id
    payload_squads_by_unit_id = squads.group_by { |s| s[:unit_id] }

    ## Calculate delta in number of each unit against the available number of that unit for the company
    ## Raise validation error if insufficient
    available_changes = {}
    payload_squads_by_unit_id.each do |unit_id, payload_unit_squads|
      if existing_squads_by_unit_id.include? unit_id
        existing_count = existing_squads_by_unit_id[unit_id].size
      else
        existing_count = 0
      end
      payload_unit_count = payload_unit_squads.size
      availability_delta = existing_count - payload_unit_count
      available_number = available_units_by_unit_id[unit_id].available

      # Inverse of the availability delta as the availablity delta is how much we are changing down the available number
      # so the inverse is how much net the available number must compare aagainst
      # Ex, 0 existing, 2 payload count, 2 available, then the availability delta is -2 as we are going to adjust down available by 2.
      #   To validate, we take the inverse (2), and compare against the available number as that 2 is what we are net adding to the company for the unit
      # Ex, 2 existing, 1 payload count, 0 available, then the availability delta is 1 as we are adjusting up by 1, as we are making 1 more available
      #   To validate we take the inverse, -1, and compare against the available number. For cases like this where the payload count is < existing, we should
      #   always pass the validation as we are adding to the available number for the unit
      unless -availability_delta <= available_number
        raise CompanyUpdateValidationError.new("Insufficient availability to create squads for unit #{unit_id} in company"\
          " #{company.id}: Existing count #{existing_count}, payload count #{payload_unit_count}, available number #{available_number}")
      end

      # Save the delta so we can update it later after we finish validating availability
      available_changes[unit_id] = availability_delta
    end

    # Check for any existing squads that have units which aren't in the payload squads list. These represent squads we
    # will be destroying and units that will give their availability back as the unit is not included at all in the new
    # squads list
    existing_squads_by_unit_id.each do |unit_id, existing_unit_squads|
      next if available_changes.include? unit_id

      available_changes[unit_id] = existing_unit_squads.size
    end

    ##### At this point, we know the company can have the new squads as they are within price and availability

    ActiveRecord::Base.transaction do
      existing_squads_by_id = existing_squads.index_by(&:id)

      new_squads = []
      squads.each do |s|
        if s[:squad_id].blank?
          ## Create new Squad records for squads without squad id
          available_unit = available_units_by_unit_id[s[:unit_id]]
          new_squads << Squad.new(company: company, vet: s[:vet], tab_category: s[:tab],
                                  category_position: s[:index], available_unit: available_unit)
        else
          ## Update existing Squads
          existing_squad = existing_squads_by_id[s[:squad_id]]
          existing_squad.update!(tab_category: s[:tab], category_position: s[:index], name: s[:name])
        end
      end
      Squad.import!(new_squads)

      ## Determine set of existing Squads with squad id not in the new list of squads. Delete these
      squad_ids_to_delete = existing_squad_ids - payload_squad_ids
      Squad.where(id: [squad_ids_to_delete]).destroy_all if squad_ids_to_delete.present?

      ## Update unit available number for every squad operation above
      available_changes.each do |unit_id, delta|
        available_unit = available_units_by_unit_id[unit_id]
        new_available_number = available_unit.available + delta
        available_unit.update!(available: [new_available_number, 0].max)
      end

      company.update!(pop: pop_new, man: man_remaining, mun: mun_remaining, fuel: fuel_remaining)
    end

    company.reload
    [company.squads, company.available_units]
  end

  def delete_company(company, override = false)
    unless can_update_company(company, override)
      raise CompanyUpdateValidationError.new("Player #{@player.id} cannot update Company #{company.id}")
    end

    company.destroy!
  end

  private

  # A company can be created for a player if they have fewer than the limit of companies for the doctrine's side
  def can_create_company(doctrine)
    side = doctrine.faction.side
    factions_for_side = Faction.where(side: side)

    @player.companies.where(faction: factions_for_side).size < MAX_COMPANIES_PER_SIDE
  end

  def can_update_company(company, override)
    company.player == @player || override
  end

  def get_uniq_squad_ids(squads)
    squads.map { |s| s[:unit_id] }.uniq
  end

  def get_uniq_units_by_id(unit_ids)
    Unit.where(id: unit_ids).index_by(&:id)
  end

  def get_total_available_resources(ruleset)
    # TODO Add resource bonuses later
    available_man = ruleset.starting_man
    available_mun = ruleset.starting_mun
    available_fuel = ruleset.starting_fuel

    [available_man, available_mun, available_fuel]
  end
end
