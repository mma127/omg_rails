require 'csv'

module Seeds
  class ResourceBonusesSeeder < ApplicationService
    FILENAME = 'lib/assets/resource_bonuses.csv'.freeze

    class << self
      def create_for_ruleset(ruleset)
        resource_bonuses = []
        resource_bonuses_csv.each do |row|
          name = row["name"]
          resource = row["resource"]
          man = row["man"]
          mun = row["mun"]
          fuel = row["fuel"]
          resource_bonuses << ResourceBonus.new(ruleset: ruleset, name: name, resource: resource,
                                                man: man, mun: mun, fuel: fuel)
        end
        ResourceBonus.import! resource_bonuses
      end

      private

      def resource_bonuses_csv
        CSV.open(FILENAME, headers: true)
      end
    end
  end
end
