require 'csv'

module Seeds
  class OffmapsSeeder < ApplicationService
    FILENAME = 'lib/assets/offmaps.csv'.freeze

    class << self
      def create_for_ruleset(ruleset)
        factions_by_name = Faction.all.index_by(&:name)
        doctrines_by_name = Doctrine.all.index_by(&:name)
        unlocks_by_name = Unlock.where(ruleset: ruleset).index_by(&:name)

        offmaps_csv.each do |row|
          name = snake_case(row["internal_name"])
          display_name = title_case(name)
          offmap = Offmap.create!(name: name,
                                  ruleset: ruleset,
                                  display_name: display_name,
                                  const_name: row["const_name"],
                                  description: row["description"],
                                  upgrade_rgd: row["upgrade_path"],
                                  ability_rgd: row["ability_path"],
                                  cooldown: row["cooldown"],
                                  duration: row["duration"],
                                  unlimited_uses: ActiveModel::Type::Boolean.new.cast(row["unlimited_uses"]),
                                  buffs: row["buffs"],
                                  debuffs: row["debuffs"],
                                  weapon_rgd: row["weapon"],
                                  shells_fired: row["shells_fired"]
          )

          # puts "name: #{name}, const_name: #{row["const_name"]}, doctrine: #{row["doctrine"]}, unlock: #{row["unlock"]}"
          doctrine_name = row["doctrine"]
          unlock_name = row["unlock"]
          if doctrine_name.present? && unlock_name.present?
            doctrine = get_doctrine_from_name(doctrine_name, doctrines_by_name)
            unlock = get_unlock_from_name(unlock_name, unlocks_by_name)
            doctrine_unlock = DoctrineUnlock.find_by!(unlock: unlock, doctrine: doctrine, ruleset: ruleset)
            restriction = Restriction.find_by!(doctrine_unlock: doctrine_unlock)
          elsif doctrine_name.present?
            doctrine = get_doctrine_from_name(doctrine_name, doctrines_by_name)
            restriction = Restriction.find_by!(doctrine: doctrine)
          elsif unlock_name.present?
            unlock = get_unlock_from_name(unlock_name, unlocks_by_name)
            restriction = Restriction.find_by!(unlock: unlock)
          else
            faction = get_faction_from_name(row["faction"], factions_by_name) # we store faction name in the doctrine column
            restriction = Restriction.find_by!(faction: faction)
          end
          EnabledOffmap.create!(restriction: restriction, offmap: offmap, mun: row["mun"].to_i, max: row["max"].to_i, ruleset: ruleset)
        end
      end

      def update_offmap_values_for_ruleset(ruleset)
        offmaps_csv.each do |row|
          name = snake_case(row["internal_name"])
          display_name = title_case(name)
          current_offmap = Offmap.find_by(name: name, ruleset_id: ruleset.id)
          current_offmap.update!(display_name: display_name,
                                 const_name: row["const_name"],
                                 description: row["description"],
                                 upgrade_rgd: row["upgrade_path"],
                                 ability_rgd: row["ability_path"],
                                 cooldown: row["cooldown"],
                                 duration: row["duration"],
                                 unlimited_uses: ActiveModel::Type::Boolean.new.cast(row["unlimited_uses"]),
                                 buffs: row["buffs"],
                                 debuffs: row["debuffs"],
                                 weapon_rgd: row["weapon"],
                                 shells_fired: row["shells_fired"])
        end
      end

      private

      def offmaps_csv
        CSV.open(FILENAME, headers: true)
      end

      def get_faction_from_name(faction_name, factions_by_name)
        if factions_by_name.include? faction_name
          factions_by_name[faction_name]
        else
          raise ArgumentError.new("Unknown faction name #{faction_name} for offmap creation")
        end
      end

      def get_doctrine_from_name(doctrine_name, doctrines_by_name)
        if doctrines_by_name.include? doctrine_name
          doctrines_by_name[doctrine_name]
        else
          raise ArgumentError.new("Unknown doctrine name #{doctrine_name} for offmap creation")
        end
      end

      def get_unlock_from_name(unlock_name, unlocks_by_name)
        if unlocks_by_name.include? unlock_name
          unlocks_by_name[unlock_name]
        else
          raise ArgumentError.new("Unknown unlock name #{unlock_name} for offmap creation")
        end
      end

      def snake_case(str)
        str.parameterize.underscore
      end

      def title_case(str)
        str.humanize.titleize
      end
    end
  end
end
