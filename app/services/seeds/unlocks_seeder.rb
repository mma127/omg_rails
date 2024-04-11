require 'csv'

module Seeds
  class UnlocksSeeder < ApplicationService
    FILENAME = 'lib/assets/doctrineabilities.csv'.freeze

    class << self
      # Create a doctrineUnlock for the unlock as our seed unlocks are 1 to 1 with doctrineUnlocks
      #
      # CSV generated from the following SQL query
      # select da_id, internalName as internal_name, CONSTNAME as const, doctrine_tree as tree, branch, tier, description from doctrineabilities
      # where branch != 0 or tier != 0 order by CONSTNAME
      def create_for_ruleset(ruleset)
        doctrines_by_name = Doctrine.all.index_by(&:name)
        doctrines_by_const = {
          INFANTRY: doctrines_by_name["infantry"],
          AIRBOURNE: doctrines_by_name["airborne"],
          ARMOUR: doctrines_by_name["armor"],

          RCA: doctrines_by_name["canadians"],
          ENGINEERS: doctrines_by_name["engineers"],
          COMMANDO: doctrines_by_name["commandos"],

          DEFENSIVE: doctrines_by_name["defensive"],
          BLITZ: doctrines_by_name["blitz"],
          TERROR: doctrines_by_name["terror"],

          SCORCHED: doctrines_by_name["scorched_earth"],
          LUFTWAFFE: doctrines_by_name["luftwaffe"],
          TANKHUNTERS: doctrines_by_name["tank_hunters"]
        }.with_indifferent_access

        unlocks = []
        doctrine_unlocks = []
        restrictions = []
        CSV.foreach(FILENAME, headers: true) do |row|
          name = row["internal_name"]
          doc = get_doc_str_from_const(row["const"])
          doctrine = doctrines_by_const[doc]

          if row["description"].blank?
            name = get_doc_location_str_from_const(row["const"])
          end

          # puts "name: #{name}, constname: #{row["const"]}, doctrine: #{doctrine.display_name}"
          is_disabled = row["vp"].to_i > 25
          unlock = Unlock.new(name: snakecase(name), const_name: row["const"], display_name: name, description: row["description"], ruleset: ruleset)
          du = DoctrineUnlock.new(doctrine: doctrine, unlock: unlock, ruleset: ruleset, vp_cost: row["vp"], tree: row["tree"], branch: row["branch"], row: row["tier"], disabled: is_disabled)

          unlocks << unlock
          doctrine_unlocks << du
          restrictions << Restriction.new(doctrine_unlock: du,
                              name: "#{doctrine.display_name} | #{unlock.display_name}",
                              description: "#{doctrine.display_name} Doctrine Unlock Restriction - #{unlock.display_name}")
          restrictions << Restriction.new(unlock: unlock, name: unlock.display_name, description: "#{unlock.display_name} - Unlock Restriction")
        end

        Unlock.import! unlocks
        DoctrineUnlock.import! doctrine_unlocks
        Restriction.import! restrictions
      end

      private

      def snakecase(str)
        str.parameterize.underscore
      end

      def get_doc_str_from_const(str)
        str.split('.').third
      end

      def get_doc_location_str_from_const(str)
        str.split('.')[2..5].join(".")
      end
    end
  end
end
