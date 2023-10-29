after :rulesets do
  ResourceBonus.create!(name: "Manpower Bonus", resource: "man", gained: 450, mun_lost: 45, fuel_lost: 40)
  ResourceBonus.create!(name: "Munitions Bonus", resource: "mun", gained: 180, man_lost: 125, fuel_lost: 40)
  ResourceBonus.create!(name: "Fuel Bonus", resource: "fuel", gained: 160, man_lost: 90, mun_lost: 30)
end
