class AvailableUnitService
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

    allowed_units_hash = get_base_faction_doctrine_unit_hash
    # TODO Unlock
    # TODO Reward
    # TODO Alpha

    # Create available units with the filtered collection of restriction units
    create_enabled_available_units(allowed_units_hash.values)
  end

  # When creating new enabled_units, start available at max resupply value
  def create_enabled_available_units(enabled_units)
    available_units = enabled_units.map do |unit_data|
      instantiate_base_available_unit(unit_data)
    end
    AvailableUnit.import!(available_units)
  end

  # When refunding a doctrine unlock, it's possible to reenable previously disabled units
  # IMPORTANT: Only handles 1 enabled_unit per unit_id for company unlocks
  def recreate_disabled_from_doctrine_unlock(units_disabled, doctrine_unlock)
    # Validate there are no current available_units for the given units
    validate_no_base_available_units_for_given(units_disabled)

    # Start with basic units available for faction and doctrine
    allowed_units_hash = get_base_faction_doctrine_unit_hash

    # Filter to only the units that were previously disabled
    allowed_units_hash = allowed_units_hash.slice(*units_disabled.map { |ud| ud.id })

    # Apply all company unlocks except the given doctrine_unlock (that is being refunded)
    company_unlocks = CompanyUnlock.where(company: @company).where.not(doctrine_unlock: doctrine_unlock)
    restrictions = company_unlocks.map do |cu|
      [cu.doctrine_unlock.restriction, cu.doctrine_unlock.unlock.restriction]
    end.flatten
    # Get only enabled_units for the company unlock restrictions and the units that were disabled
    enabled_units = EnabledUnit.includes(:unit).where(restriction: restrictions, unit: units_disabled)
    enabled_units_by_unit_id = enabled_units.index_by(&:unit_id) # IMPORTANT: Only handles 1 enabled_unit per unit_id for company unlocks

    # Merge
    enabled_units_by_unit_id = merge_allowed_units(allowed_units_hash, enabled_units_by_unit_id)

    # Get disabled_units for the company_unlock restrictions and units that were disabled (in the unlikely case that multiple unlocks disable units)
    disabled_units = DisabledUnit.where(restriction: restrictions, unit: units_disabled)
    disabled_units_by_unit_id = disabled_units.index_by(&:unit_id)
    enabled_units_by_unit_id = remove_disabled_units(enabled_units_by_unit_id, disabled_units_by_unit_id)

    if enabled_units_by_unit_id.blank?
      Rails.logger.info("No enabled_units found to recreate that were disabled by doctrineUnlock #{doctrine_unlock.id} for company #{@company.id}")
    else
      Rails.logger.info("Found #{enabled_units_by_unit_id.size} enabled_units, creating available units that were disabled by doctrineUnlock #{doctrine_unlock.id} for company #{@company.id}")
      create_enabled_available_units(enabled_units_by_unit_id.values)
    end
  end

  # Given units to remove, remove all available_units (all types) from the company associated
  # with those units. Destroy squads using those available units.
  def remove_available_units(units_to_remove)
    available_units = AvailableUnit.where(company: @company, unit: units_to_remove)
    available_units.destroy_all # squads destroyed via dependent destroy
  end

  private

  # Calculates the basic set of units available for the company's faction and doctrine
  def get_base_faction_doctrine_unit_hash
    # Get restriction for Faction, then find all faction allowed units
    faction_restriction = Restriction.find_by(faction: @faction)
    faction_allowed_units = get_enabled_unit_hash faction_restriction

    # Get restriction for Doctrine, then find all doctrine allowed units
    doctrine_restriction = Restriction.find_by(doctrine: @doctrine)
    doctrine_allowed_units = get_enabled_unit_hash doctrine_restriction
    doctrine_disabled_units = get_disabled_unit_hash doctrine_restriction

    allowed_units_hash = faction_allowed_units
    allowed_units_hash = merge_allowed_units(allowed_units_hash, doctrine_allowed_units)
    remove_disabled_units(allowed_units_hash, doctrine_disabled_units)
  end

  def get_enabled_unit_hash(restriction)
    EnabledUnit.where(restriction: restriction).index_by(&:unit_id)
  end

  def get_disabled_unit_hash(restriction)
    DisabledUnit.where(restriction: restriction).index_by(&:unit_id)
  end

  def merge_allowed_units(existing_units_hash, restricted_units_hash)
    # TODO This only works for EnabledUnit where more specific ones replace the more general one
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

  def validate_no_base_available_units_for_given(units)
    unless BaseAvailableUnit.where(company: @company, unit: units).empty?
      raise AvailableUnitsValidationError.new("Company #{company.id} already has existing base available units for a subset of #{units.pluck(:id)}")
    end
  end
end
