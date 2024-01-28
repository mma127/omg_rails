after :rulesets do
  war_ruleset = Ruleset.find_by(ruleset_type: Ruleset.ruleset_types[:war], is_active: true)

  ResourceBonus.create!(name: "Manpower Bonus", resource: "man", man: 450, mun: -45, fuel: -40, ruleset: war_ruleset)
  ResourceBonus.create!(name: "Munitions Bonus", resource: "mun", man: -125, mun: 180, fuel: -40, ruleset: war_ruleset)
  ResourceBonus.create!(name: "Fuel Bonus", resource: "fuel", man: -90, mun: -30, fuel: 160, ruleset: war_ruleset)
end
