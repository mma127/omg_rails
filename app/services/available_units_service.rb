class AvailableUnitsService
  class AvailableUnitsValidationError < StandardError; end

  def initialize(company)
    @company = company
    @player = company.player
    @faction = company.faction
    @doctrine = company.doctrine
  end

  # Given a new company, determine the available units for that company
  # Taking into account:
  #   Faction units
  #   Doctrine units
  #   Unlock units
  #   Reward units
  #   Alpha units
  #
  #   ** Ignores existing available units for now **
  def build_new_company_available_units
    # Get restriction for Faction, then find all faction allowed units
    faction_restriction = Restriction.find_by(faction: @faction)
    faction_allowed_units = get_enabled_unit_hash faction_restriction

    # Get restriction for Doctrine, then find all doctrine allowed units
    doctrine_restriction = Restriction.find_by(doctrine: @doctrine)
    doctrine_allowed_units = get_enabled_unit_hash doctrine_restriction
    doctrine_disabled_units = get_disabled_unit_hash doctrine_restriction

    # TODO Unlock
    # TODO Reward
    # TODO Alpha

    allowed_units_hashes = faction_allowed_units
    allowed_units_hashes = merge_allowed_units(allowed_units_hashes, doctrine_allowed_units)
    allowed_units_hashes = remove_disabled_units(allowed_units_hashes, doctrine_disabled_units)

    create_available_units(allowed_units_hashes)
  end

  private

  def get_enabled_unit_hash(restriction)
    EnabledUnit.where(restriction: restriction).index_by(&:unit_id)
  end

  def get_disabled_unit_hash(restriction)
    DisabledUnit.where(restriction: restriction).index_by(&:unit_id)
  end

  def merge_allowed_units(existing_units_hash, restricted_units_hash)
    # TODO This only works for EnabledRestrictionUnit where more specific ones replace the more general one
    if restricted_units_hash.present?
      existing_units_hash = existing_units_hash.merge(restricted_units_hash)
    end
    existing_units_hash
  end

  def remove_disabled_units(existing_units_hash, disabled_units_hash)
    if disabled_units_hash.present?
      existing_units_hash = existing_units_hash.except(*disabled_units_hash.keys)
    end
    existing_units_hash
  end

  # When creating new available_units, start available at max resupply value
  def create_available_units(unit_hashes)
    validate_empty_available_units

    available_units = []
    unit_hashes.values.map do |unit_data|
      available_units << AvailableUnit.new(unit: unit_data.unit, company: @company, available: unit_data.resupply_max,
                                           resupply: unit_data.resupply, resupply_max: unit_data.resupply_max,
                                           company_max: unit_data.company_max, pop: unit_data.pop,
                                           man: unit_data.man, mun: unit_data.mun, fuel: unit_data.fuel,
                                           callin_modifier: unit_data.callin_modifier)
    end
    AvailableUnit.import!(available_units)
  end

  def validate_empty_available_units
    raise AvailableUnitsValidationError.new("Company #{@company.id} has existing AvailableUnits") unless AvailableUnit.where(company: @company).empty?
  end
end
