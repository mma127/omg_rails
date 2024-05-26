class StatsUnitsService < ApplicationService
  def self.fetch_for_const_name(const_name, ruleset_id)
    su = StatsUnit.find_by(const_name: const_name, ruleset_id: ruleset_id)
    return nil if su.blank?

    loadout = su.data.with_indifferent_access[:loadout]
    if loadout.present?
      stats_entities = StatsEntity.where(reference: loadout.keys, ruleset_id: ruleset_id)
      weapons = stats_entities.map { |entity| entity.data["weapons"] }.flatten
      weapons.push(*squad_upgrade_apply_weapons(su))

      if weapons.present?
        stats_weapons = StatsWeapon.where(reference: weapons, ruleset_id: ruleset_id)
      end
    end
    [su, stats_entities, stats_weapons]
  end

  def self.squad_upgrade_apply_weapons(stats_unit)
    stats_unit.data.with_indifferent_access[:squad_upgrade_apply_weapons]
  end
end
