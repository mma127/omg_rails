require 'json'

module Seeds
  class SgaStatsSeeder < ApplicationService
    UNITS_JSON_FILENAME = 'lib/assets/stats/units.json'.freeze
    ENTITIES_JSON_FILENAME = 'lib/assets/stats/entities.json'.freeze
    WEAPONS_JSON_FILENAME = 'lib/assets/stats/weapons.json'.freeze
    UPGRADES_JSON_FILENAME = 'lib/assets/stats/upgrades.json'.freeze
    SLOT_ITEMS_JSON_FILENAME = 'lib/assets/stats/slot_items.json'.freeze
    DOC_MARKERS_JSON_FILENAME = 'lib/assets/stats/docmarkers.json'.freeze

    def initialize(ruleset)
      @ruleset = ruleset
    end

    def create_for_ruleset
      ActiveRecord::Base.transaction do
        delete_existing_stats_for_ruleset

        create_stats_units_for_ruleset
        create_stats_entities_for_ruleset
        create_stats_weapons_for_ruleset
        create_stats_upgrades_for_ruleset

        create_stats_slot_items_for_ruleset
        create_stats_doc_markers_for_ruleset
        create_stats_abilities_for_ruleset
      end
    end

    private

    def delete_existing_stats_for_ruleset
      StatsUnit.where(ruleset_id: @ruleset.id).destroy_all
      StatsEntity.where(ruleset_id: @ruleset.id).destroy_all
      StatsWeapon.where(ruleset_id: @ruleset.id).destroy_all
      StatsUpgrade.where(ruleset_id: @ruleset.id).destroy_all
      StatsSlotItem.where(ruleset_id: @ruleset.id).destroy_all
    end

    def create_stats_units_for_ruleset
      file = File.read(UNITS_JSON_FILENAME)
      data_hash = JSON.parse(file)
      stats_units = []
      data_hash.each do |value|
        stats_units << StatsUnit.new(
          ruleset_id: @ruleset.id,
          reference: value['reference'],
          const_name: "#{value['faction']}.#{value['constname']}",
          data: value
        )
      end
      StatsUnit.import! stats_units
      Rails.logger.info("Loaded #{stats_units.size} StatsUnits for ruleset #{@ruleset.id}")
      puts "Loaded #{stats_units.size} StatsUnits for ruleset #{@ruleset.id}"
    end

    def create_stats_entities_for_ruleset
      file = File.read(ENTITIES_JSON_FILENAME)
      data_hash = JSON.parse(file)
      stats_entities = []
      data_hash.each do |value|
        stats_entities << StatsEntity.new(
          ruleset_id: @ruleset.id,
          reference: value['reference'],
          data: value
        )
      end
      StatsEntity.import! stats_entities
      Rails.logger.info("Loaded #{stats_entities.size} StatsEntities for ruleset #{@ruleset.id}")
      puts "Loaded #{stats_entities.size} StatsEntities for ruleset #{@ruleset.id}"
    end

    def create_stats_weapons_for_ruleset
      file = File.read(WEAPONS_JSON_FILENAME)
      data_hash = JSON.parse(file)
      stats_weapons = []
      data_hash.each do |value|
        stats_weapons << StatsWeapon.new(
          ruleset_id: @ruleset.id,
          reference: value['reference'],
          data: value
        )
      end
      StatsWeapon.import! stats_weapons
      Rails.logger.info("Loaded #{stats_weapons.size} StatsWeapons for ruleset #{@ruleset.id}")
      puts "Loaded #{stats_weapons.size} StatsWeapons for ruleset #{@ruleset.id}"
    end

    def create_stats_upgrades_for_ruleset
      file = File.read(UPGRADES_JSON_FILENAME)
      data_hash = JSON.parse(file)
      stats_upgrades = []
      data_hash.each do |value|
        stats_upgrades << StatsUpgrade.new(
          ruleset_id: @ruleset.id,
          reference: value['reference'],
          const_name: upgrade_const_name(value),
          data: value
        )
      end
      StatsUpgrade.import! stats_upgrades
      Rails.logger.info("Loaded #{stats_upgrades.size} StatsUpgrades for ruleset #{@ruleset.id}")
      puts "Loaded #{stats_upgrades.size} StatsUpgrades for ruleset #{@ruleset.id}"
    end

    def create_stats_slot_items_for_ruleset
      file = File.read(SLOT_ITEMS_JSON_FILENAME)
      data_hash = JSON.parse(file)
      stats_slot_items = []
      data_hash.each do |value|
        stats_slot_items << StatsSlotItem.new(
          ruleset_id: @ruleset.id,
          reference: value['reference'],
          data: value
        )
      end
      StatsSlotItem.import! stats_slot_items
      Rails.logger.info("Loaded #{stats_slot_items.size} StatsSlotItems for ruleset #{@ruleset.id}")
      puts "Loaded #{stats_slot_items.size} StatsSlotItems for ruleset #{@ruleset.id}"
    end

    def create_stats_doc_markers_for_ruleset
      file = File.read(DOC_MARKERS_JSON_FILENAME)
      data_hash = JSON.parse(file)
      stats_doc_markers = []
      data_hash.each do |key, value|
        stats_doc_markers << StatsDocMarker.new(
          ruleset_id: @ruleset.id,
          reference: value['value'],
          const_name: key,
          faction: value['faction']
        )
      end
      StatsDocMarker.import! stats_doc_markers
      Rails.logger.info("Loaded #{stats_doc_markers.size} StatsDocMarkers for ruleset #{@ruleset.id}")
      puts "Loaded #{stats_doc_markers.size} StatsDocMarkers for ruleset #{@ruleset.id}"
    end

    def create_stats_abilities_for_ruleset

    end

    def upgrade_const_name(upgrade)
      if upgrade['constname'].present? && upgrade['faction'].present?
        "#{upgrade['faction']}.#{upgrade['constname']}"
      else
        nil
      end
    end
  end
end
