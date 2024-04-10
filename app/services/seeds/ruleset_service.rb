require 'csv'

module Seeds
  class RulesetService < ApplicationService
    FILENAME = 'lib/assets/rulesets.csv'.freeze

    def self.create_new_ruleset(ruleset_type, name)
      Ruleset.transaction do
        new_ruleset_csv_row = get_ruleset_csv_row(ruleset_type)
        raise ArgumentError.new "No row found matching ruleset type #{ruleset_type} in seed file [#{FILENAME}]" if new_ruleset_csv_row.blank?

        active_ruleset = get_active_ruleset(ruleset_type)
        if active_ruleset
          active_ruleset.update!(is_active: false)
        end

        Ruleset.create!(name: name,
                        ruleset_type: ruleset_type,
                        is_active: true,
                        description: new_ruleset_csv_row["description"],
                        starting_man: new_ruleset_csv_row["starting_man"],
                        starting_mun: new_ruleset_csv_row["starting_mun"],
                        starting_fuel: new_ruleset_csv_row["starting_fuel"],
                        starting_vps: new_ruleset_csv_row["starting_vps"],
                        max_vps: new_ruleset_csv_row["max_vps"],
                        max_resource_bonuses: new_ruleset_csv_row["max_resource_bonuses"]
        )
      end
    end

    private

    def self.get_ruleset_csv_row(ruleset_type)
      csv = CSV.read(FILENAME, headers: true)
      csv.find { |row| row["type"] == ruleset_type }
    end

    def self.get_active_ruleset(ruleset_type)
      Ruleset.find_by(is_active: true, ruleset_type: ruleset_type)
    end
  end
end
