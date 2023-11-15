class RestrictionUnitsService
  def initialize(ruleset_id, faction_id, doctrine_id)
    @ruleset_id = ruleset_id
    @faction_id = faction_id
    @doctrine_id = doctrine_id # optional
  end

  # Retrieve restriction units by ruleset and faction, optionally narrowed by doctrine
  def get_restriction_units
    faction_enabled_units = EnabledUnit.includes(:restriction, :unit).where(restriction: faction_restriction, ruleset: ruleset)
    doctrine_enabled_units = EnabledUnit.includes(:restriction, :unit).where(restriction: doctrine_restriction, ruleset: ruleset)
    doctrine_disabled_units = DisabledUnit.includes(:restriction, :unit).where(restriction: doctrine_restriction, ruleset: ruleset)

    faction_enabled_units_by_unit_id = faction_enabled_units.index_by(&:unit_id)
    doctrine_enabled_units_by_unit_id = doctrine_enabled_units.index_by(&:unit_id)
    doctrine_disabled_units_by_unit_id = doctrine_disabled_units.index_by(&:unit_id)

    # For each unit_id, group all RestrictionUnits together
    unit_ids = Set.new(faction_enabled_units_by_unit_id.keys +
                         doctrine_enabled_units_by_unit_id.keys +
                         doctrine_disabled_units_by_unit_id.keys)
    result = unit_ids.map do |unit_id|
      build_result(unit_id, faction_enabled_units_by_unit_id, doctrine_enabled_units_by_unit_id, doctrine_disabled_units_by_unit_id)
    end

    result.sort do |a, b|
      # Sort on unit sort_priority (smaller is better), then unit name alpha
      unit_a = a[:active_restriction_unit].unit
      unit_b = b[:active_restriction_unit].unit
      if unit_a.sort_priority < unit_b.sort_priority
        -1
      elsif unit_a.sort_priority > unit_b.sort_priority
        1
      else
        unit_a.name <=> unit_b.name
      end
    end
  end

  private

  # Specificity from most to least
  # 1. Doctrine disable
  # 2. Doctrine enable
  # 3. Faction enable
  def build_result(unit_id, faction_enabled_units_by_unit_id, doctrine_enabled_units_by_unit_id, doctrine_disabled_units_by_unit_id)
    faction_enabled_unit = faction_enabled_units_by_unit_id[unit_id]
    doctrine_enabled_unit = doctrine_enabled_units_by_unit_id[unit_id]
    doctrine_disabled_unit = doctrine_disabled_units_by_unit_id[unit_id]

    restriction_units = []
    if doctrine_disabled_unit.present?
      restriction_units << doctrine_disabled_unit
    end
    if doctrine_enabled_unit.present?
      restriction_units << doctrine_enabled_unit
    end
    if faction_enabled_unit.present?
      restriction_units << faction_enabled_unit
    end

    {
      unit_id: unit_id,
      active_restriction_unit: restriction_units.first,
      overridden_restriction_units: restriction_units[1..]
    }
  end

  def base_restriction
    if doctrine_restriction.present?
      doctrine_restriction
    else
      faction_restriction
    end
  end

  def ruleset
    @_ruleset ||= Ruleset.find_by(id: @ruleset_id)
  end

  def faction
    @_faction ||= Faction.find_by(id: @faction_id)
  end

  def doctrine
    @_doctrine ||= Doctrine.find_by(id: @doctrine_id)
  end

  def faction_restriction
    @_faction_restriction ||= Restriction.find_by(faction_id: @faction_id)
  end

  def doctrine_restriction
    @_doctrine_restriction ||= Restriction.find_by(doctrine_id: @doctrine_id)
  end
end