class StatsUnitsService < ApplicationService
  def self.fetch_for_const_name(name, const_name, ruleset_id)
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

    upgrade_weapons = enabled_upgrade_weapons(name, ruleset_id)
    stats_weapons_upgrades = StatsWeapon.where(reference: upgrade_weapons, ruleset_id: ruleset_id)

    [su, stats_entities, stats_weapons, stats_weapons_upgrades]
  end

  def self.squad_upgrade_apply_weapons(stats_unit)
    stats_unit.data.with_indifferent_access[:squad_upgrade_apply_weapons].keys
  end

  def self.enabled_upgrade_weapons(unit_name, ruleset_id)
    unit = Unit.find_by(name: unit_name)
    enabled_upgrades = EnabledUpgrade.includes(:upgrade)
                                     .joins(:units)
                                     .where(ruleset_id: ruleset_id,
                                            units: { id: unit.id })
    upgrade_consts = enabled_upgrades.filter { |eu| eu.upgrade.weapon_related? }
                                     .map { |eu| eu.upgrade.const_name }
    stats_upgrades = StatsUpgrade.where(ruleset_id: ruleset_id, const_name: upgrade_consts)
    direct_upgrade_weapon_refs = stats_upgrades.map { |su| su.added_weapon_refs }.flatten.compact.uniq

    slot_item_refs = stats_upgrades.map { |su| su.added_slot_items_refs }.flatten.compact.uniq
    stats_slot_items = StatsSlotItem.where(ruleset_id: ruleset_id, reference: slot_item_refs)
    slot_item_weapon_refs = stats_slot_items.map { |si| si.data.dig("weapon", "weapon") }.flatten.compact.uniq


    direct_upgrade_weapon_refs + slot_item_weapon_refs
  end
end
