class RestrictionUpgradesService < RestrictionsService
  # Retrieve restriction upgrades by ruleset and faction, optionally narrowed by doctrine
  # Group by upgrade id, and include a list of associated units in the result
  def get_restriction_upgrades
    faction_enabled_upgrades = fetch_enabled_upgrades(faction_restriction)
    doctrine_enabled_upgrades = fetch_enabled_upgrades(doctrine_restriction)
    doctrine_disabled_upgrades = fetch_disabled_upgrades(doctrine_restriction)

    # Handle each upgrade-unit pair individually while determining the active restrictionUpgrade
    # Here the distinct record is the "upgrade_id|unit_id" pair, represented by a string key
    faction_enabled_upgrade_units = map_restriction_upgrade_unit_to_upgrade_unit(faction_enabled_upgrades)
    doctrine_enabled_upgrade_units = map_restriction_upgrade_unit_to_upgrade_unit(doctrine_enabled_upgrades)
    doctrine_disabled_upgrade_units = map_restriction_upgrade_unit_to_upgrade_unit(doctrine_disabled_upgrades)

    # For each upgrade-unit pair, group all RestrictionUpgrades together
    upgrade_unit_keys = Set.new(faction_enabled_upgrade_units.keys +
                                  doctrine_enabled_upgrade_units.keys +
                                  doctrine_disabled_upgrade_units.keys)

    results = upgrade_unit_keys.map do |upgrade_unit_key|
      build_upgrade_unit_result(upgrade_unit_key, faction_enabled_upgrade_units, doctrine_enabled_upgrade_units, doctrine_disabled_upgrade_units)
    end

    # once we have the active restrictionUpgrade and list of overridden restrictionUpgrades for every upgrade-unit pair
    # we can group by restriction upgrade paths (ie, upgrade-unit pairs with the same active restrictionUpgrade id and the same
    # overridden restrictionUpgrades should be grouped by active upgrade so we have a list of units per active upgrade)

    results_grouped_by_restriction_upgrade_path = results.reduce({}) do |acc, result|
      key = result[:restriction_upgrade_ids]
      if acc.has_key?(key)
        acc[key][:unit_names] << result[:unit_name]
      else
        acc[key] = {
          upgrade_unit_key: result[:upgrade_unit_key],
          restriction_upgrade_id_path_key: key,
          active_restriction_upgrade: result[:active_restriction_upgrade],
          overridden_restriction_upgrades: result[:overridden_restriction_upgrades],
          upgrade_id: result[:upgrade_id],
          unit_names: [result[:unit_name]]
        }
      end

      acc
    end.values # Return just the values for sorting

    # Have objects of active and overridden restriction upgrades, with list of associated unit names
    # Sort by upgrade id
    results_grouped_by_restriction_upgrade_path.sort do |a, b|
      a[:upgrade_id] <=> b[:upgrade_id]
    end
  end

  private

  def build_upgrade_unit_result(upgrade_unit_key, faction_enabled_upgrade_units, doctrine_enabled_upgrade_units, doctrine_disabled_upgrade_units)
    faction_enabled_upgrade_unit = faction_enabled_upgrade_units[upgrade_unit_key]
    doctrine_enabled_upgrade_unit = doctrine_enabled_upgrade_units[upgrade_unit_key]
    doctrine_disabled_upgrade_unit = doctrine_disabled_upgrade_units[upgrade_unit_key]

    restriction_upgrades = []
    restriction_upgrade_ids = []
    if doctrine_disabled_upgrade_unit.present?
      restriction_upgrades << doctrine_disabled_upgrade_unit.restriction_upgrade
      restriction_upgrade_ids << doctrine_disabled_upgrade_unit.restriction_upgrade.id
      unit = doctrine_disabled_upgrade_unit.unit
    end
    if doctrine_enabled_upgrade_unit.present?
      restriction_upgrades << doctrine_enabled_upgrade_unit.restriction_upgrade
      restriction_upgrade_ids << doctrine_enabled_upgrade_unit.restriction_upgrade.id
      unit = doctrine_enabled_upgrade_unit.unit
    end
    if faction_enabled_upgrade_unit.present?
      restriction_upgrades << faction_enabled_upgrade_unit.restriction_upgrade
      restriction_upgrade_ids << faction_enabled_upgrade_unit.restriction_upgrade.id
      unit = faction_enabled_upgrade_unit.unit
    end
    upgrade_id, unit_id = split_upgrade_unit_key(upgrade_unit_key)

    {
      upgrade_unit_key: upgrade_unit_key,
      active_restriction_upgrade: restriction_upgrades.first,
      overridden_restriction_upgrades: restriction_upgrades[1..],
      restriction_upgrade_ids: restriction_upgrade_ids.join("|"),
      upgrade_id: upgrade_id,
      unit_name: unit&.name
    }
  end

  def map_restriction_upgrade_unit_to_upgrade_unit(restriction_upgrades)
    restriction_upgrades.reduce({}) do |acc, restriction_upgrade|
      restriction_upgrade_units = restriction_upgrade.restriction_upgrade_units
      restriction_upgrade_units.each do |ruu|
        key = create_upgrade_unit_key(restriction_upgrade.upgrade_id, ruu.unit_id)
        acc[key] = ruu
      end
      acc
    end
  end

  def create_upgrade_unit_key(upgrade_id, unit_id)
    "#{upgrade_id}|#{unit_id}"
  end

  def split_upgrade_unit_key(upgrade_unit_key)
    upgrade_unit_key.split("|")
  end

  def fetch_enabled_upgrades(restriction)
    EnabledUpgrade.includes(:restriction, :upgrade, restriction_upgrade_units: :unit)
                  .where(restriction: restriction, ruleset: ruleset)
  end

  def fetch_disabled_upgrades(restriction)
    DisabledUpgrade.includes(:restriction, :upgrade, restriction_upgrade_units: :unit)
                   .where(restriction: restriction, ruleset: ruleset)
  end
end
