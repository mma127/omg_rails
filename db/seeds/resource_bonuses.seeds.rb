after :rulesets do
  war_ruleset = Ruleset.find_by(ruleset_type: Ruleset.ruleset_types[:war], is_active: true)

  resource_bonuses = []
  CSV.foreach("db/seeds/resource_bonuses.csv", headers: true) do |row|
    name = row["name"]
    resource = row["resource"]
    man = row["man"]
    mun = row["mun"]
    fuel = row["fuel"]
    resource_bonuses << ResourceBonus.new(ruleset: war_ruleset, name: name, resource: resource,
                                          man: man, mun: mun, fuel: fuel)
  end
  ResourceBonus.import! resource_bonuses
end
