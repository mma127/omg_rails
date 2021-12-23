after :doctrines do
  #################################################################################
  ################################### Americans ###################################
  ## Common
  Infantry.create!(name: "riflemen", const_name: "ALLY.RIFLEMEN", display_name: "Riflemen", unitwide_upgrade_slots: 1, upgrade_slots: 1)
  Infantry.create!(name: "engineers", const_name: "ALLY.ENGINEERS", display_name: "Engineers", unitwide_upgrade_slots: 1, upgrade_slots: 2)

  SupportTeam.create!(name: "allied_sniper", const_name: "ALLY.SNIPER", display_name: "Sniper")
  SupportTeam.create!(name: "allied_hmg", const_name: "ALLY.MG", display_name: ".30cal MG Team")
  SupportTeam.create!(name: "allied_mortar", const_name: "ALLY.MORTAR", display_name: "60mm Mortar Team")
  SupportTeam.create!(name: "allied_57atg", const_name: "ALLY.AT_GUN", display_name: "57mm AT Gun", upgrade_slots: 1)

  LightVehicle.create!(name: "jeep", const_name: "ALLY.JEEP", display_name: "Jeep", upgrade_slots: 1)
  LightVehicle.create!(name: "allied_halftrack", const_name: "ALLY.HALFTRACK", display_name: "Halftrack", upgrade_slots: 1)
  LightVehicle.create!(name: "quad_halftrack", const_name: "ALLY_QUAD", display_name: "Quad .50cal HT")
  LightVehicle.create!(name: "greyhound", const_name: "ALLY.GREYHOUND", display_name: "M8 Greyhound", upgrade_slots: 2)
  LightVehicle.create!(name: "t17", const_name: "ALLY.T17", display_name: "T17", upgrade_slots: 2)

  Tank.create!(name: "sherman", const_name: "ALLY.SHERMAN", display_name: "M4 Sherman", upgrade_slots: 2)
  Tank.create!(name: "sherman_croc", const_name: "ALLY.CROC", display_name: "Sherman Crocodile", upgrade_slots: 2)
  Tank.create!(name: "m10", const_name: "ALLY.TANK_DESTROYER", display_name: "M10 Wolverine", upgrade_slots: 1)
  Tank.create!(name: "m18", const_name: "ALLY.M18", display_name: "M18 Hellcat", upgrade_slots: 1)

  ## Infantry
  Infantry.create!(name: "rangers", const_name: "ALLY.RANGERS", display_name: "Rangers", unitwide_upgrade_slots: 1, upgrade_slots: 1)
  Infantry.create!(name: "ambush_riflemen", const_name: "ALLY.AMBUSH", display_name: "Ambush Riflemen", upgrade_slots: 1)

  SupportTeam.create!(name: "spotter", const_name: "ALLY.SPOTTER", display_name: "Spotter", upgrade_slots: 1)
  SupportTeam.create!(name: "allied_officer", const_name: "ALLY.US_OFFICER", display_name: "Infantry Officer", upgrade_slots: 1)

  Tank.create!(name: "jumbo", const_name: "ALLY.JUMBO", display_name: "Sherman Jumbo", upgrade_slots: 2)

  Emplacement.create!(name: "howitzer", const_name: "ALLY.HOWITZER", display_name: "105mm Howitzer", upgrade_slots: 0)

  ## Airborne
  Infantry.create!(name: "airborne", const_name: "ALLY.PARATROOPERS", display_name: "Airborne", unitwide_upgrade_slots: 1, upgrade_slots: 7, is_airdrop: true)
  Infantry.create!(name: "assault_airborne", const_name: "ALLY.PARA_ASSAULT", display_name: "Assault Airborne", unitwide_upgrade_slots: 1, upgrade_slots: 4, is_airdrop: true)

  SupportTeam.create!(name: "airborne_hmg", const_name: "ALLY.PARA_MG", display_name: "Airborne 30cal MG Team", upgrade_slots: 1, is_airdrop: true)
  SupportTeam.create!(name: "airborne_mortar", const_name: "ALLY.PARA_MORTAR", display_name: "Airborne 60mm Mortar Team", upgrade_slots: 1, is_airdrop: true)
  SupportTeam.create!(name: "airborne_atg", const_name: "ALLY.PARA_AT_GUN", display_name: "Airborne 57mm AT Gun", upgrade_slots: 1, is_airdrop: true)
  SupportTeam.create!(name: "airborne_sniper", const_name: "ALLY.PARA_SNIPER", display_name: "Airborne Sniper", upgrade_slots: 1, is_airdrop: true)

  Tank.create!(name: "chaffee", const_name: "ALLY.CHAFFEE", display_name: "M24 Chaffee", upgrade_slots: 2)

  ## Armor
  Infantry.create!(name: "mech_inf", const_name: "ALLY.MECH_INFANTRY", display_name: "Mechanized Infantry", unitwide_upgrade_slots: 1, upgrade_slots: 1)

  Tank.create!(name: "sherman_105", const_name: "ALLY.HOWITZER_SHERMAN", display_name: "105mm Sherman", upgrade_slots: 2)
  Tank.create!(name: "calliope", const_name: "ALLY.CALLIOPE", display_name: "Sherman Calliope", upgrade_slots: 2)
  Tank.create!(name: "easy_eight", const_name: "ALLY.EASY_EIGHTY", display_name: "M4A3E8 Sherman Easy Eight", upgrade_slots: 2)
  Tank.create!(name: "jackson", const_name: "ALLY.JACKSON", display_name: "M36 Jackson", upgrade_slots: 0)
  Tank.create!(name: "pershing", const_name: "ALLY.PERSHING", display_name: "M26 Pershing", upgrade_slots: 1)

  #################################################################################
  #################################### British ####################################

  #################################################################################
  ################################### Wehrmacht ###################################

  #################################################################################
  ################################## Panzer Elite #################################
end
