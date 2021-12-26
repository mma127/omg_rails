class CompanyService
  class CompanyCreationValidationError < StandardError; end

  class CompanyDeletionValidationError < StandardError; end

  MAX_COMPANIES_PER_SIDE = 2.freeze

  WAR_RULESET = "war".freeze

  def initialize(player)
    @player = player
  end

  def create_company(doctrine, name)
    unless can_create_company(doctrine)
      raise CompanyCreationValidationError("Player #{@player.id} has too many #{doctrine.faction.side} companies, cannot create another one.")
    end

    # Get ruleset
    ruleset = Ruleset.find_by_name(WAR_RULESET)

    # Create Company entity
    new_company = Company.create!(name: name,
                                  player: @player,
                                  doctrine: doctrine,
                                  faction: doctrine.faction,
                                  vps_earned: 0,
                                  man: ruleset.starting_man,
                                  mun: ruleset.starting_mun,
                                  fuel: ruleset.starting_fuel,
                                  pop: 0
    )

    # Create AvailableUnits for Company
    available_units_service = AvailableUnitsService.new(new_company)
    available_units_service.build_new_company_available_units

    new_company
  end

  def delete_company(company, override = false)
    unless can_delete_company(company, override)
      raise CompanyDeletionValidationError("Player #{@player.id} cannot delete Company #{company.id}")
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

  def can_delete_company(company, override)
    company.player == @player || override
  end
end
