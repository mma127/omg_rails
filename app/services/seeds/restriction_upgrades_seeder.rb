require 'csv'

module Seeds
  class RestrictionUpgradesSeeder < ApplicationService
    DISABLED_UPGRADES_FILENAME = 'lib/assets/disabled_upgrades.csv'
    UPGRADE_SWAPS_FILENAME = 'lib/assets/upgrade_swaps.csv'

    def initialize(ruleset)
      @ruleset = ruleset

      @units_by_name = Unit.all.index_by(&:name)
      @upgrades_by_name = Upgrade.all.index_by(&:name)

      @factions_by_name = Faction.includes(:restriction).all.index_by(&:name)
      @doctrines_by_name = Doctrine.includes(:restriction).all.index_by(&:name)
      @unlocks_by_name = Unlock.includes(:restriction).where(ruleset: @ruleset).all.index_by(&:name)
      @doctrine_unlocks_by_names = DoctrineUnlock.includes(:doctrine, :unlock, :restriction).where(ruleset: @ruleset)
                                                 .all
                                                 .index_by { |du| doctrine_unlock_name(du.doctrine.name, du.unlock.name) }

      @faction_restrictions_by_name = {}
      @doctrine_restrictions_by_name = {}
      @unlock_restrictions_by_name = {}
      @doctrine_unlock_restrictions_by_names = {}
    end

    def create_for_ruleset
      restriction_upgrade_units = []
      upgrade_swaps = []
      upgrade_swap_units = []

      csv_paths.each do |path|
        CSV.foreach(path, headers: true) do |row|
          # puts "#{row["upgrade"]} | #{row["const"]} | #{row['faction_restriction']}, #{row['doctrine_restriction']}, #{row['unlock_restriction']} | #{row["unit"]}"
          man = row['man']
          mun = row['mun']
          fuel = row['fuel']
          pop = row['pop']
          uses = row['uses']
          max = row['max']
          slots = row['slots']
          unitwide_slots = row['unitwide_slots']

          unit = @units_by_name[row['unit']]
          upgrade = @upgrades_by_name[row['upgrade']]
          restriction = get_restriction(row['faction_restriction'], row['doctrine_restriction'], row['unlock_restriction'])
          enabled_upgrade = EnabledUpgrade.find_or_create_by!(restriction: restriction, upgrade: upgrade, ruleset: @ruleset,
                                               man: man, mun: mun, fuel: fuel, pop: pop, uses: uses, max: max,
                                               upgrade_slots: slots, unitwide_upgrade_slots: unitwide_slots,
                                               priority: 1)
          restriction_upgrade_units << RestrictionUpgradeUnit.new(restriction_upgrade: enabled_upgrade, unit: unit)

        end
      end

      disabled_upgrades_csv.each do |row|
        unit = @units_by_name[row['unit']]
        upgrade = @upgrades_by_name[row['upgrade']]
        restriction = get_restriction(row['faction_restriction'], row['doctrine_restriction'], row['unlock_restriction'])
        disabled_upgrade = DisabledUpgrade.find_or_create_by!(restriction: restriction, upgrade: upgrade, ruleset: @ruleset, priority: 1)
        restriction_upgrade_units << RestrictionUpgradeUnit.new(restriction_upgrade: disabled_upgrade, unit: unit)
      end

      upgrade_swaps_csv.each do |row|
        old_upgrade = @upgrades_by_name[row['old_upgrade']]
        new_upgrade = @upgrades_by_name[row['new_upgrade']]
        unlock = @unlocks_by_name[row['unlock_restriction']]
        unit = @units_by_name[row['unit']]

        upgrade_swap = UpgradeSwap.new(unlock: unlock, old_upgrade: old_upgrade, new_upgrade: new_upgrade)
        upgrade_swaps << upgrade_swap
        upgrade_swap_units << UpgradeSwapUnit.new(upgrade_swap: upgrade_swap, unit: unit)
      end

      # Cannot bulk import RestrictionUpgrades as they are immediately needed for restrictionUpgradeUnits and since the rows duplicate the
      # RestrictionUpgrade values we only want to refer to the first RestrictionUpgrade created for the batch of similar RestrictionUpgradeUnits
      RestrictionUpgradeUnit.import! restriction_upgrade_units
      UpgradeSwap.import! upgrade_swaps
      UpgradeSwapUnit.import! upgrade_swap_units
    end

    private

    def csv_paths
      %w[lib/assets/enabled_upgrades_ame.csv lib/assets/enabled_upgrades_cmw.csv lib/assets/enabled_upgrades_wehr.csv lib/assets/enabled_upgrades_pe.csv]
    end

    def disabled_upgrades_csv
      CSV.open(DISABLED_UPGRADES_FILENAME, headers: true)
    end

    def upgrade_swaps_csv
      CSV.open(UPGRADE_SWAPS_FILENAME, headers: true)
    end

    def get_restriction(faction_name, doctrine_name, unlock_name)
      if faction_name.present?
        unless @faction_restrictions_by_name.include? faction_name
          faction = @factions_by_name[faction_name]
          @faction_restrictions_by_name[faction_name] = faction.restriction
        end
        @faction_restrictions_by_name[faction_name]
      elsif unlock_name.present? && doctrine_name.present?
        du_name = doctrine_unlock_name(doctrine_name, unlock_name)
        unless @doctrine_unlock_restrictions_by_names.include? du_name
          doctrine_unlock = @doctrine_unlocks_by_names[du_name]
          @doctrine_unlock_restrictions_by_names[du_name] = doctrine_unlock.restriction
        end
        @doctrine_unlock_restrictions_by_names[du_name]
      elsif doctrine_name.present?
        if @doctrine_restrictions_by_name.include? doctrine_name
        else
          doctrine = @doctrines_by_name[doctrine_name]
          @doctrine_restrictions_by_name[doctrine_name] = doctrine.restriction
        end
        @doctrine_restrictions_by_name[doctrine_name]
      elsif unlock_name.present?
        unless @unlock_restrictions_by_name.include? unlock_name
          unlock = @unlocks_by_name[unlock_name]
          @unlock_restrictions_by_name[unlock_name] = unlock.restriction
        end
        @unlock_restrictions_by_name[unlock_name]
      else
        raise ArgumentError.new "Invalid combination of faction name [#{faction_name}], doctrine name [#{doctrine_name}], and unlock name [#{unlock_name}]"
      end
    end

    def doctrine_unlock_name(doctrine_name, unlock_name)
      "#{doctrine_name}|#{unlock_name}"
    end
  end
end
