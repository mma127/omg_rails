after :units do
  # Factions and Doctrines already have their standard Restriction created
  # This should contain unlock restrictions

  # Americans
  americans = Faction.find_by_name("americans")

  ## Infantry
  infantry = Doctrine.find_by_name("infantry")


  ## Airborne
  airborne = Doctrine.find_by_name("airborne")


  ## Armor
  armor = Doctrine.find_by_name("armor")

end
