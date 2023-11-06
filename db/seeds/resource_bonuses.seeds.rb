after :rulesets do
  ResourceBonus.create!(name: "Manpower Bonus", resource: "man", man: 450, mun: -45, fuel: -40)
  ResourceBonus.create!(name: "Munitions Bonus", resource: "mun", man: -125, mun: 180, fuel: -40)
  ResourceBonus.create!(name: "Fuel Bonus", resource: "fuel", man: -90, mun: -30, fuel: 160)
end
