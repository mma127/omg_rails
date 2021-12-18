after :doctrines do
  # Americans
  americans = Faction.find_by_name("americans")
  ## Common
  # Unit.create!()

  ## Infantry
  infantry = Doctrine.find_by_name("infantry")

  ## Airborne
  airborne = Doctrine.find_by_name("airborne")

  ## Armor
  armor = Doctrine.find_by_name("armor")

end
