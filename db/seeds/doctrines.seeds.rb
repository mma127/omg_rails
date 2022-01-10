after :factions do
  americans = Faction.find_by_name("americans")
  infantry = Doctrine.create!(name: "infantry", display_name: "Infantry", const_name: "OMGUPG.ALLY.INFANTRYDOC", internal_name: "ALLY.DOC.Infantry", faction: americans)
  airborne = Doctrine.create!(name: "airborne", display_name: "Airborne", const_name: "OMGUPG.ALLY.AIRBORNEDOC", internal_name: "ALLY.DOC.Airborne", faction: americans)
  armor = Doctrine.create!(name: "armor", display_name: "Armor", const_name: "OMGUPG.ALLY.ARMOURDOC", internal_name: "ALLY.DOC.Armor", faction: americans)

  wehr = Faction.find_by_name("wehrmacht")
  defensive = Doctrine.create!(name: "defensive", display_name: "Defensive", const_name: "OMGUPG.AXIS.DEFENSEDOC", internal_name: "AXIS.DOC.Defense", faction: wehr)
  terror = Doctrine.create!(name: "terror", display_name: "Terror", const_name: "OMGUPG.AXIS.TERRORDOC", internal_name: "AXIS.DOC.Terror", faction: wehr)
  blitz = Doctrine.create!(name: "blitz", display_name: "Blitzkrieg", const_name: "OMGUPG.AXIS.BLITZDOC", internal_name: "AXIS.DOC.Blitz", faction: wehr)

  pe = Faction.find_by_name("panzer_elite")
  tank_hunters = Doctrine.create!(name: "tank_hunters", display_name: "Tank Hunters", const_name: "OMGUPG.PE.TANKHUNTERDOC", internal_name: "PE.DOC.tank_hunters", faction: pe)
  scorched_earth = Doctrine.create!(name: "scorched_earth", display_name: "Scorched Earth", const_name: "OMGUPG.PE.SCORCHEDDOC", internal_name: "PE.DOC.scorched_earth", faction: pe)
  luftwaffe= Doctrine.create!(name: "luftwaffe", display_name: "Luftwaffe", const_name: "OMGUPG.PE.LUFTDOC", internal_name: "PE.DOC.luftwaffe", faction: pe)

  british = Faction.find_by_name("british")
  engineers = Doctrine.create!(name: "engineers", display_name: "Engineers", const_name: "OMGUPG.CMW.ROYALENGIESDOC", internal_name: "CMW.DOC.engineers", faction: british)
  canadians = Doctrine.create!(name: "canadians", display_name: "Canadians", const_name: "OMGUPG.CMW.ARTYDOC", internal_name: "CMW.DOC.artillery", faction: british)
  commandos = Doctrine.create!(name: "commandos", display_name: "Commandos", const_name: "OMGUPG.CMW.COMMANDODOC", internal_name: "CMW.DOC.commandos", faction: british)

  # Restrictions at doctrine level
  Restriction.create!(name: "Infantry doctrine", description: "For the Infantry doctrine", doctrine: infantry)
  Restriction.create!(name: "Airborne doctrine", description: "For the Airborne doctrine", doctrine: airborne)
  Restriction.create!(name: "Armor doctrine", description: "For the Armor doctrine", doctrine: armor)

  Restriction.create!(name: "Defensive doctrine", description: "For the Defensive doctrine", doctrine: defensive)
  Restriction.create!(name: "Terror doctrine", description: "For the Terror doctrine", doctrine: terror)
  Restriction.create!(name: "Blitzkrieg doctrine", description: "For the Blitzkrieg doctrine", doctrine: blitz)

  Restriction.create!(name: "Tank Hunters doctrine", description: "For the Tank Hunters doctrine", doctrine: tank_hunters)
  Restriction.create!(name: "Scorched Earth doctrine", description: "For the Scorched Earth doctrine", doctrine: scorched_earth)
  Restriction.create!(name: "Luftwaffe doctrine", description: "For the Luftwaffe doctrine", doctrine: luftwaffe)

  Restriction.create!(name: "Royal Engineers doctrine", description: "For the Royal Engineers doctrine", doctrine: engineers)
  Restriction.create!(name: "Royal Canadian doctrine", description: "For the Royal Canadians doctrine", doctrine: canadians)
  Restriction.create!(name: "Commandos doctrine", description: "For the Commandos doctrine", doctrine: commandos)
end
