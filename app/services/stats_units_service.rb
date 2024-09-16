class StatsUnitsService < ApplicationService

  def self.call(unit_name, const_name, ruleset_id)
    new(unit_name, const_name, ruleset_id).fetch_for_const_name
  end

  attr_reader :unit_name, :const_name, :ruleset_id

  def initialize(unit_name, const_name, ruleset_id)
    @unit_name = unit_name
    @const_name = const_name
    @ruleset_id = ruleset_id
  end

  def fetch_for_const_name
    return nil if stats_unit.blank?

    [stats_unit, stats_entities, stats_weapons, loadout_weapon_count, enabled_upgrade_weapon_count, enabled_upgrades, stats_upgrades]
  end

  private

  def stats_unit
    @_stats_unit ||= StatsUnit.find_by(const_name: const_name, ruleset_id: ruleset_id)
  end

  def stats_entities
    @_stats_entities ||= begin
                           loadout = stats_unit.data.with_indifferent_access[:loadout]
                           if loadout.present?
                             StatsEntity.where(reference: loadout.keys, ruleset_id: ruleset_id)
                           else
                             []
                           end
                         end
  end

  def stats_weapons
    StatsWeapon.where(reference: loadout_weapon_refs + enabled_upgrade_weapons_refs, ruleset_id: ruleset_id)
  end

  def loadout_weapon_count
    counts = loadout_weapon_refs.tally
    counts.map { |ref, count| { reference: ref, count: count } }
  end

  def enabled_upgrade_weapon_count
    weapon_stats_upgrades.map do |stats_upgrade|
      upgrade_const = stats_upgrade.const_name
      direct_weapon_refs = direct_upgrade_weapon_refs_by_upgrade_const[upgrade_const]

      weapon_counts = direct_weapon_refs.reduce({}) do |acc, value|
        acc[value] = total_number_of_entities
        acc
      end

      slot_item_ref_counts = {}
      slot_items_refs = weapon_upgrade_slot_item_refs_by_upgrade_const[upgrade_const]
      slot_items_refs.each do |sir|
        si = weapon_upgrade_slot_items_by_reference[sir]
        si_weapon = dig_slot_item_weapon(si)

        next if direct_weapon_refs.include?(si_weapon) # The direct weapon refs will already replace this weapon for the upgrade, don't need the slot item

        if slot_item_ref_counts.include? sir
          slot_item_ref_counts[sir][:count] += 1
        else
          slot_item_ref_counts[sir] = {
            weapon: si_weapon,
            count: 1
          }
        end
        next if si_weapon.blank?

        if weapon_counts.include? si_weapon
          weapon_counts[si_weapon] += 1
        else
          weapon_counts[si_weapon] = 1
        end
      end
      upgrade = enabled_upgrade_consts_to_upgrade[upgrade_const]
      {
        upgrade_id: upgrade.id,
        upgrade_const: upgrade_const,
        upgrade_name: upgrade.name,
        weapon_count: weapon_counts.map { |k, v| { reference: k, count: v } },
        slot_item_count: slot_item_ref_counts.map { |k, v| { reference: k, weapon: v[:weapon], count: v[:count] } }
      }
    end
  end

  def stats_upgrades
    @_stats_upgrades ||= StatsUpgrade.where(ruleset_id: ruleset_id, const_name: enabled_upgrades_consts)
  end

  def unit
    @_unit ||= Unit.find_by(name: unit_name)
  end

  def loadout_weapon_refs
    weapons = []
    if loadout.present?
      weapons = stats_entities.map do |entity|
        count = loadout[entity.reference].to_i
        Array.new(count, entity.data["weapons"])
      end.flatten
      weapons.push(*squad_upgrade_apply_weapons)
    end
    weapons
  end

  def enabled_upgrades
    @_enabled_upgrades ||= EnabledUpgrade.includes(:upgrade)
                                         .joins(:units)
                                         .where(ruleset_id: ruleset_id,
                                                units: { id: unit.id })
  end

  def enabled_upgrades_consts
    @_enabled_upgrades_consts ||= enabled_upgrades.map { |eu| eu.upgrade.const_name }
  end

  def enabled_upgrade_consts_to_upgrade
    @_enabled_upgrade_consts_to_upgrade ||= enabled_upgrades
                                           .filter { |eu| eu.upgrade.weapon_related? }
                                           .map { |eu| [eu.upgrade.const_name, eu.upgrade] }
                                           .to_h
  end

  def enabled_upgrade_weapons_refs
    direct_upgrade_weapon_refs = direct_upgrade_weapon_refs_by_upgrade_const.values.flatten.compact.uniq
    weapon_upgrade_slot_item_weapon_refs = weapon_upgrade_slot_items_by_reference.values.map { |si| dig_slot_item_weapon(si) }.compact.uniq
    direct_upgrade_weapon_refs + weapon_upgrade_slot_item_weapon_refs
  end

  def squad_upgrade_apply_weapons
    stats_unit.data.with_indifferent_access[:squad_upgrade_apply_weapons].map { |k, v| Array.new(v, k) }.flatten
  end

  def weapon_stats_upgrades
    @_weapon_stats_upgrades ||= begin
                                  upgrade_consts = enabled_upgrade_consts_to_upgrade.keys
                                  stats_upgrades.filter { |su| upgrade_consts.include? su.const_name }
                                end
  end

  def direct_upgrade_weapon_refs_by_upgrade_const
    @_direct_upgrade_weapon_refs_by_upgrade_const ||=
      weapon_stats_upgrades.map { |su| [su.const_name, su.added_weapon_refs] }.to_h
  end

  def weapon_upgrade_slot_item_refs_by_upgrade_const
    @_weapon_upgrade_slot_item_refs_by_upgrade_const ||=
      weapon_stats_upgrades.map { |su| [su.const_name, su.added_slot_items_refs] }.to_h
  end

  def weapon_upgrade_slot_items_by_reference
    @_weapon_upgrade_slot_items_by_reference ||=
      begin
        slot_item_refs = weapon_upgrade_slot_item_refs_by_upgrade_const.values.flatten.compact.uniq.map(&:downcase)
        stats_slot_items = StatsSlotItem.where(ruleset_id: ruleset_id, reference: slot_item_refs)
        stats_slot_items.map { |si| [si.reference, si] }.to_h
      end
  end

  def dig_slot_item_weapon(slot_item)
    slot_item.data.dig("weapon", "weapon")&.downcase
  end

  def loadout
    @_loadout ||= stats_unit.data.with_indifferent_access[:loadout]
  end

  def total_number_of_entities
    @_total_number_of_entities ||= loadout.values.map { |v| v.to_i }.sum
  end
end
