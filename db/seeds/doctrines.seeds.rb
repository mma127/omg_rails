after :factions do
  americans = Faction.find_by_name("americans")
  Doctrine.create!(name: "infantry", display_name: "Infantry", const_name: "OMGUPG.ALLY.INFANTRYDOC", internal_name: "ALLY.DOC.Infantry", faction: americans)
  Doctrine.create!(name: "airborne", display_name: "Airborne", const_name: "OMGUPG.ALLY.AIRBORNEDOC", internal_name: "ALLY.DOC.Airborne", faction: americans)
  Doctrine.create!(name: "armor", display_name: "Armor", const_name: "OMGUPG.ALLY.ARMOURDOC", internal_name: "ALLY.DOC.Armor", faction: americans)

  wehr = Faction.find_by_name("wehrmacht")
  Doctrine.create!(name: "defensive", display_name: "Defensive", const_name: "OMGUPG.AXIS.DEFENSEDOC", internal_name: "AXIS.DOC.Defense", faction: wehr)
  Doctrine.create!(name: "terror", display_name: "Terror", const_name: "OMGUPG.AXIS.TERRORDOC", internal_name: "AXIS.DOC.Terror", faction: wehr)
  Doctrine.create!(name: "blitz", display_name: "Blitzkrieg", const_name: "OMGUPG.AXIS.BLITZDOC", internal_name: "AXIS.DOC.Blitz", faction: wehr)

  pe = Faction.find_by_name("panzer_elite")
  Doctrine.create!(name: "tank_hunters", display_name: "Tank Hunters", const_name: "OMGUPG.PE.TANKHUNTERDOC", internal_name: "PE.DOC.tank_hunters", faction: pe)
  Doctrine.create!(name: "scorched_earth", display_name: "Scorched Earth", const_name: "OMGUPG.PE.SCORCHEDDOC", internal_name: "PE.DOC.scorched_earth", faction: pe)
  Doctrine.create!(name: "luftwaffe", display_name: "Luftwaffe", const_name: "OMGUPG.PE.LUFTDOC", internal_name: "PE.DOC.luftwaffe", faction: pe)

  british = Faction.find_by_name("british")
  Doctrine.create!(name: "engineers", display_name: "Engineers", const_name: "OMGUPG.CMW.ROYALENGIESDOC", internal_name: "CMW.DOC.engineers", faction: british)
  Doctrine.create!(name: "royal_artillery", display_name: "Canadians", const_name: "OMGUPG.CMW.ARTYDOC", internal_name: "CMW.DOC.artillery", faction: british)
  Doctrine.create!(name: "commandos", display_name: "Commandos", const_name: "OMGUPG.CMW.COMMANDODOC", internal_name: "CMW.DOC.commandos", faction: british)
end
