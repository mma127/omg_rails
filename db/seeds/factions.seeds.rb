after :rulesets do
  americans = Faction.create!(name: "americans", display_name: "Americans", const_name: "ALLY", internal_name: "Factions.Allies", side: "allied")
  british = Faction.create!(name: "british", display_name: "British", const_name: "CMW", internal_name: "Factions.British2ndArmy", side: "allied")
  wehrmacht = Faction.create!(name: "wehrmacht", display_name: "Wehrmacht", const_name: "AXIS", internal_name: "Factions.Axis", side: "axis")
  pe = Faction.create!(name: "panzer_elite", display_name: "Panzer Elite", const_name: "PE", internal_name: "Factions.PanzerElite", side: "axis")

  Restriction.create!(name: "American faction", description: "For the American faction", faction: americans)
  Restriction.create!(name: "British faction", description: "For the British faction", faction: british)
  Restriction.create!(name: "Wehrmacht faction", description: "For the Wehrmacht faction", faction: wehrmacht)
  Restriction.create!(name: "Panzer Elite faction", description: "For the Panzer Elite faction", faction: pe)
end
