require 'csv'

module Seeds
  class RestrictionUnitsSeeder < ApplicationService
    FILENAME = 'lib/assets/unit_restrictions.csv'.freeze
    SWAPS_FILENAME = 'lib/assets/unit_swaps.csv'.freeze

    def initialize(ruleset)
      @ruleset = ruleset
      @units_by_name = Unit.all.index_by(&:name)

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

    # Create RestrictionUnits to associate Units with Restrictions and their costs per restriction
    # This associates Units with a Faction, Doctrine, or Unlock, and allows them to be priced separately
    # For example, a Riflemen unit in the Infantry doctrine can have different pricing and resupply than the
    # generic American faction Riflemen unit
    def create_for_ruleset
      restriction_units = []
      unit_restrictions_csv.each do |row|
        unit_name = row["unit_name"]
        type = row["type"]
        faction_name = row["faction_name"]
        doctrine_name = row["doctrine_name"]
        unlock_name = row["unlock_name"]
        pop = row["pop"]
        man = row["man"]
        mun = row["mun"]
        fuel = row["fuel"]
        resupply = row["resupply"]
        resupply_max = row["resupply_max"]
        company_max = row["company_max"]
        priority = row["priority"]
        upgrade_slots = row["upgrade_slots"]
        unitwide_upgrade_slots = row["unitwide_upgrade_slots"]

        unit = get_unit(unit_name)
        restriction = get_restriction(faction_name, doctrine_name, unlock_name)
        type_class = get_type_class(type)

        restriction_unit = type_class.new(restriction: restriction, unit: unit, ruleset: @ruleset,
                                          man: man, mun: mun, fuel: fuel, pop: pop,
                                          resupply: resupply, resupply_max: resupply_max, company_max: company_max, priority: priority,
                                          upgrade_slots: upgrade_slots, unitwide_upgrade_slots: unitwide_upgrade_slots)

        # Run after save callback to generate internal description https://github.com/zdennis/activerecord-import?tab=readme-ov-file#callbacks
        restriction_unit.run_callbacks(:save) { false }

        restriction_units << restriction_unit
      end

      unit_swaps = []
      unit_swaps_csv.each do |row|
        unlock_name = row["unlock_name"]
        old_unit_name = row["old_unit_name"]
        new_unit_name = row["new_unit_name"]

        unlock = get_unlock(unlock_name)
        old_unit = get_unit(old_unit_name)
        new_unit = get_unit(new_unit_name)
        unit_swaps << UnitSwap.new(unlock: unlock, old_unit: old_unit, new_unit: new_unit)
      end

      RestrictionUnit.import! restriction_units
      UnitSwap.import! unit_swaps
    end

    private

    def unit_restrictions_csv
      CSV.open(FILENAME, headers: true)
    end

    def unit_swaps_csv
      CSV.open(SWAPS_FILENAME, headers: true)
    end

    def get_unit(unit_name)
      if @units_by_name.include? unit_name
        @units_by_name[unit_name]
      else
        raise ArgumentError.new("Unknown unit name #{unit_name}")
      end
    end

    def get_unlock(unlock_name)
      if @unlocks_by_name.include? unlock_name
        @unlocks_by_name[unlock_name]
      else
        raise ArgumentError.new("Unknown unlock name #{unlock_name}")
      end
    end

    def get_restriction(faction_name, doctrine_name, unlock_name)
      if faction_name.present?
        unless @faction_restrictions_by_name.include? faction_name
          faction = @factions_by_name[faction_name]
          @faction_restrictions_by_name[faction_name] = faction.restriction
        end
        @faction_restrictions_by_name[faction_name]
      elsif doctrine_name.present? && unlock_name.present?
        du_name = doctrine_unlock_name(doctrine_name, unlock_name)
        unless @doctrine_unlock_restrictions_by_names.include? du_name
          doctrine_unlock = @doctrine_unlocks_by_names[du_name]
          @doctrine_unlock_restrictions_by_names[du_name] = doctrine_unlock.restriction
        end
        @doctrine_unlock_restrictions_by_names[du_name]
      elsif doctrine_name.present?
        unless @doctrine_restrictions_by_name.include? doctrine_name
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
        raise ArgumentError.new("Unknown restriction: faction name #{faction_name}, doctrine name: #{doctrine_name}, unlock name: #{unlock_name}")
      end
    end

    def get_type_class(type)
      class_type = type.constantize
      if class_type < RestrictionUnit
        class_type
      else
        raise ArgumentError.new("Class name #{type} is not a subclass of RestrictionUnit")
      end
    end

    def doctrine_unlock_name(doctrine_name, unlock_name)
      "#{doctrine_name}|#{unlock_name}"
    end
  end
end
