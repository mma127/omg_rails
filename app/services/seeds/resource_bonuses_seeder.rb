require 'csv'

module Seeds
  class ResourceBonusesSeeder < ApplicationService
    FILENAME = 'lib/assets/resource_bonuses.csv'.freeze

    class << self
      def create_for_ruleset(ruleset)
        resource_bonuses = []
        CSV.foreach(FILENAME, headers: true) do |row|
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
    end
  end
end
