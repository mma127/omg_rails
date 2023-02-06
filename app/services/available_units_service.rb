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
    validate_empty_available_units

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

    # Create available units with the filtered collection of restriction units
    create_base_available_units(allowed_units_hashes.values)
  end

  # When creating new base_available_units, start available at max resupply value
  def create_base_available_units(restriction_units)
    available_units = restriction_units.map do |unit_data|
      instantiate_base_available_unit(unit_data)
    end
    AvailableUnit.import!(available_units)
  end

  # Given units to remove, remove all available_units (all types) from the company associated
  # with those units. Destroy squads using those available units.
  def remove_available_units(units_to_remove)
    available_units = AvailableUnit.where(company: @company, unit: units_to_remove)
    available_units.destroy_all # squads destroyed via dependent destroy
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

  def instantiate_base_available_unit(restriction_unit)
    BaseAvailableUnit.new(unit: restriction_unit.unit, company: @company, available: restriction_unit.resupply_max,
                          resupply: restriction_unit.resupply, resupply_max: restriction_unit.resupply_max,
                          company_max: restriction_unit.company_max, pop: restriction_unit.pop,
                          man: restriction_unit.man, mun: restriction_unit.mun, fuel: restriction_unit.fuel,
                          callin_modifier: restriction_unit.callin_modifier)
  end

  def validate_empty_available_units
    raise AvailableUnitsValidationError.new("Company #{@company.id} has existing AvailableUnits") unless AvailableUnit.where(company: @company).empty?
  end
end
