after :doctrines do
  #################################################################################
  ################################### Americans ###################################
  ## Common
  Infantry.create!(name: "riflemen", const_name: "ALLY.RIFLEMEN", display_name: "Riflemen", unitwide_upgrade_slots: 1, upgrade_slots: 1, model_count: 6)
  Infantry.create!(name: "engineers", const_name: "ALLY.ENGINEERS", display_name: "Engineers", unitwide_upgrade_slots: 1, upgrade_slots: 2, model_count: 3)

  SupportTeam.create!(name: "sniper_allied", const_name: "ALLY.SNIPER", display_name: "Sniper", model_count: 1)
  SupportTeam.create!(name: "30cal_hmg", const_name: "ALLY.MG", display_name: ".30cal MG Team", model_count: 3)
  SupportTeam.create!(name: "mortar_allied", const_name: "ALLY.MORTAR", display_name: "60mm Mortar Team", model_count: 3)
  SupportTeam.create!(name: "57mm_atg", const_name: "ALLY.AT_GUN", display_name: "57mm AT Gun", upgrade_slots: 1)

  LightVehicle.create!(name: "jeep", const_name: "ALLY.JEEP", display_name: "Jeep", upgrade_slots: 1)
  LightVehicle.create!(name: "halftrack_allied", const_name: "ALLY.HALFTRACK", display_name: "Halftrack", upgrade_slots: 1, transport_squad_slots: 3, transport_model_slots: 12)
  LightVehicle.create!(name: "quad_halftrack", const_name: "ALLY_QUAD", display_name: "Quad .50cal HT")
  LightVehicle.create!(name: "greyhound", const_name: "ALLY.GREYHOUND", display_name: "M8 Greyhound", upgrade_slots: 2)
  LightVehicle.create!(name: "t17", const_name: "ALLY.T17", display_name: "T17 Armored Car", upgrade_slots: 2)

  Tank.create!(name: "sherman", const_name: "ALLY.SHERMAN", display_name: "M4 Sherman", upgrade_slots: 2)
  Tank.create!(name: "sherman_croc", const_name: "ALLY.CROC", display_name: "Sherman Crocodile", upgrade_slots: 2)
  Tank.create!(name: "m10", const_name: "ALLY.TANK_DESTROYER", display_name: "M10 Wolverine", upgrade_slots: 1)
  Tank.create!(name: "m18", const_name: "ALLY.M18", display_name: "M18 Hellcat", upgrade_slots: 1)

  ## Infantry
  Infantry.create!(name: "rangers", const_name: "ALLY.RANGERS", display_name: "Rangers", unitwide_upgrade_slots: 1, upgrade_slots: 1, model_count: 6)
  Infantry.create!(name: "ambush_riflemen", const_name: "ALLY.AMBUSH", display_name: "Ambush Riflemen", upgrade_slots: 1, model_count: 3)

  SupportTeam.create!(name: "spotter", const_name: "ALLY.SPOTTER", display_name: "Spotter", upgrade_slots: 1, model_count: 1)
  SupportTeam.create!(name: "officer_infantry", const_name: "ALLY.US_OFFICER", display_name: "Infantry Officer", upgrade_slots: 1, model_count: 1)

  Tank.create!(name: "jumbo", const_name: "ALLY.JUMBO", display_name: "Sherman Jumbo", upgrade_slots: 2)

  Emplacement.create!(name: "howitzer", const_name: "ALLY.HOWITZER", display_name: "105mm Howitzer", upgrade_slots: 0)

  ## Airborne
  Infantry.create!(name: "airborne", const_name: "ALLY.PARATROOPERS", display_name: "Airborne", unitwide_upgrade_slots: 1, upgrade_slots: 7, model_count: 6, is_airdrop: true)
  Infantry.create!(name: "assault_airborne", const_name: "ALLY.PARA_ASSAULT", display_name: "Assault Airborne", unitwide_upgrade_slots: 1, upgrade_slots: 4, model_count: 5, is_airdrop: true)

  SupportTeam.create!(name: "airborne_hmg", const_name: "ALLY.PARA_MG", display_name: "Airborne 30cal MG Team", upgrade_slots: 1, model_count: 3, is_airdrop: true)
  SupportTeam.create!(name: "airborne_mortar", const_name: "ALLY.PARA_MORTAR", display_name: "Airborne 60mm Mortar Team", upgrade_slots: 1, model_count: 3, is_airdrop: true)
  SupportTeam.create!(name: "airborne_atg", const_name: "ALLY.PARA_AT_GUN", display_name: "Airborne 57mm AT Gun", upgrade_slots: 1, is_airdrop: true)
  SupportTeam.create!(name: "airborne_sniper", const_name: "ALLY.PARA_SNIPER", display_name: "Airborne Sniper", upgrade_slots: 1, model_count: 1, is_airdrop: true)

  Tank.create!(name: "chaffee", const_name: "ALLY.CHAFFEE", display_name: "M24 Chaffee", upgrade_slots: 2)

  ## Armor
  Infantry.create!(name: "mech_inf", const_name: "ALLY.MECH_INFANTRY", display_name: "Mechanized Infantry", unitwide_upgrade_slots: 1, model_count: 4, upgrade_slots: 1)

  Tank.create!(name: "sherman_105", const_name: "ALLY.HOWITZER_SHERMAN", display_name: "105mm Sherman", upgrade_slots: 2)
  Tank.create!(name: "calliope", const_name: "ALLY.CALLIOPE", display_name: "Sherman Calliope", upgrade_slots: 2)
  Tank.create!(name: "easy_eight", const_name: "ALLY.EASY_EIGHTY", display_name: "M4A3E8 Sherman Easy Eight", upgrade_slots: 2)
  Tank.create!(name: "jackson", const_name: "ALLY.JACKSON", display_name: "M36 Jackson", upgrade_slots: 0)
  Tank.create!(name: "pershing", const_name: "ALLY.PERSHING", display_name: "M26 Pershing", upgrade_slots: 1)

  #################################################################################
  #################################### British ####################################
  ## Common
  Infantry.create!(name: "infantry_section", const_name: "CMW.TOMMIES", display_name: "Infantry Section",
                   unitwide_upgrade_slots: 0, upgrade_slots: 1, model_count: 5)
  Infantry.create!(name: "recon_section", const_name: "CMW.RECON_TOMMIES", display_name: "Recon Section",
                   unitwide_upgrade_slots: 0, upgrade_slots: 1, model_count: 5)
  Infantry.create!(name: "sappers", const_name: "CMW.SAPPERS", display_name: "Sappers",
                   unitwide_upgrade_slots: 0, upgrade_slots: 1, model_count: 4)
  Infantry.create!(name: "expert_sappers", const_name: "CMW.SAPPERS_EXPERT", display_name: "Expert Sappers",
                   unitwide_upgrade_slots: 0, upgrade_slots: 1, model_count: 3)

  SupportTeam.create!(name: "lt", const_name: "CMW.LT", display_name: "Lieutenant", upgrade_slots: 1, model_count: 1)
  SupportTeam.create!(name: "captain", const_name: "CMW.CAPTAIN", display_name: "Captain", upgrade_slots: 1, model_count: 1)
  SupportTeam.create!(name: "mortar_british", const_name: "CMW.MORTAR", display_name: "3-inch Mortar Team", model_count: 3)
  SupportTeam.create!(name: "vickers_hmg", const_name: "CMW.TWOMAN_HMG", display_name: "Vickers HMG Team", model_count: 3)
  SupportTeam.create!(name: "17pdr", const_name: "CMW.SEVENTEENPOUNDER", display_name: "17-pounder AT Gun")

  LightVehicle.create!(name: "universal_carrier", const_name: "CMW.UNIVERAL_CARRIER", display_name: "Universal Carrier",
                       upgrade_slots: 1, transport_squad_slots: 1, transport_model_slots: 6, model_count: 6)
  LightVehicle.create!(name: "bren_carrier", const_name: "CMW.BRENGUN", display_name: "Bren Gun Carrier",
                       upgrade_slots: 1, model_count: 6)
  LightVehicle.create!(name: "staghound", const_name: "CMW.STAGHOUND", display_name: "Staghound")

  Tank.create!(name: "stuart", const_name: "CMW.STUART", display_name: "Stuart")
  Tank.create!(name: "cromwell", const_name: "CMW.CROMWELL", display_name: "Cromwell")
  Tank.create!(name: "cct", const_name: "CMW.COMMANDTANK", display_name: "Cromwell Command Tank")
  Tank.create!(name: "kangaroo", const_name: "CMW.KANGAROO", display_name: "Kangaroo Carrier",
               transport_squad_slots: 4, transport_model_slots: 15)
  Tank.create!(name: "firefly", const_name: "CMW.SHERMAN_FIREFLY", display_name: "Sherman Firefly")

  Emplacement.create!(name: "25pdr", const_name: "CMW.TWENTYFIVEPOUNDER", display_name: "25-pounder Field Gun")
  Emplacement.create!(name: "bofors", const_name: "CMW.BOFORS", display_name: "Bofors 40mm")

  ## RCA
  Infantry.create!(name: "canadian_section", const_name: "CMW.TOMMIES_CANUK", display_name: "Canadian Infantry Section",
                   unitwide_upgrade_slots: 0, upgrade_slots: 1, model_count: 5)
  Infantry.create!(name: "ssf", const_name: "CMW.SSF", display_name: "Devil's Brigade",
                   unitwide_upgrade_slots: 0, upgrade_slots: 1, model_count: 4)

  Tank.create!(name: "stuart_recce", const_name: "CMW.STUART_RECON", display_name: "Stuart Recce")
  Tank.create!(name: "comet", const_name: "CMW.COMET", display_name: "Comet")
  Tank.create!(name: "priest", const_name: "CMW.PRIEST", display_name: "Priest")

  ## Commandos
  Infantry.create!(name: "commandos", const_name: "CMW.COMMANDOS", display_name: "Commandos",
                   unitwide_upgrade_slots: 0, upgrade_slots: 6, model_count: 6)
  Infantry.create!(name: "piat_commandos", const_name: "CMW.PIAT_COMMANDO", display_name: "PIAT Commandos",
                   unitwide_upgrade_slots: 0, upgrade_slots: 1, model_count: 3)
  Infantry.create!(name: "polish_commandos", const_name: "CMW.POLES", display_name: "Polish Paratroopers",
                   unitwide_upgrade_slots: 0, upgrade_slots: 1, model_count: 6)

  SupportTeam.create!(name: "commando_2pdr", const_name: "CMW.TWO_POUNDER", display_name: "Commando 2pdr",
                      model_count: 3)
  SupportTeam.create!(name: "commando_hmg", const_name: "CMW.COMMANDO_HMG", display_name: "Commando HMG Team",
                      model_count: 3)
  SupportTeam.create!(name: "commando_mortar", const_name: "CMW.COMMANDO_MORTAR", display_name: "Commando 3-inch Mortar Team",
                      model_count: 3)

  LightVehicle.create!(name: "tetrarch", const_name: "CMW.TETRARCH", display_name: "Tetrarch",
                       model_count: 6)
  LightVehicle.create!(name: "sas_jeep", const_name: "CMW.SAS_JEEP", display_name: "SAS Jeep",
                       model_count: 6)

  Glider.create!(name: "infantry_glider", const_name: "CMW.INF_GLIDER", display_name: "Infantry Glider (2 Infantry Slots)",
                 transport_squad_slots: 2, transport_model_slots: 12)
  Glider.create!(name: "armor_glider", const_name: "CMW.TET_GLIDER", display_name: "Armor Glider (4 Infantry Slots or 2 Vehicle Slots)",
                 transport_squad_slots: 4, transport_model_slots: 18)

  ## RSE
  Tank.create!(name: "churchill", const_name: "CMW.CHURCHILL", display_name: "Churchill")
  Tank.create!(name: "churchill_avre", const_name: "CMW.AVRE", display_name: "Churchill AVRE")
  Tank.create!(name: "churchill_croc", const_name: "CMW.CROC", display_name: "Churchill Crocodile")
  Tank.create!(name: "churchill_cct", const_name: "CMW.CHURCHILL_CCT", display_name: "Churchill Command Tank")
  Tank.create!(name: "stuart_flame", const_name: "CMW.STUART_CROC", display_name: "Stuart Flamethrower")

  #################################################################################
  ################################### Wehrmacht ###################################
  ## Common
  Infantry.create!(name: "volksgrenadiers", const_name: "AXIS.VOLKS", display_name: "Volksgrenadiers",
                   unitwide_upgrade_slots: 1, upgrade_slots: 3, model_count: 5)
  Infantry.create!(name: "grenadiers", const_name: "AXIS.GRENS", display_name: "Grenadiers",
                   unitwide_upgrade_slots: 1, upgrade_slots: 2, model_count: 4)
  Infantry.create!(name: "pioneers", const_name: "AXIS.PIONEER", display_name: "Pioneers",
                   unitwide_upgrade_slots: 1, upgrade_slots: 5, model_count: 2)
  Infantry.create!(name: "kch", const_name: "AXIS.KCH", display_name: "Knights Cross Holders",
                   unitwide_upgrade_slots: 1, upgrade_slots: 1, model_count: 3)

  SupportTeam.create!(name: "medic", const_name: "AXIS.MEDIC", display_name: "Combat Medic",
                      upgrade_slots: 1, model_count: 1)
  SupportTeam.create!(name: "mg42", const_name: "AXIS.HMG", display_name: "MG42 Team",
                      upgrade_slots: 3, model_count: 3)
  SupportTeam.create!(name: "mortar_axis", const_name: "AXIS.MORTAR", display_name: "81mm Mortar Team",
                      upgrade_slots: 3, model_count: 3)
  SupportTeam.create!(name: "pak38", const_name: "AXIS.PAK", display_name: "Pak 38")
  SupportTeam.create!(name: "sniper_axis", const_name: "AXIS.SNIPER", display_name: "Sniper", model_count: 1)
  SupportTeam.create!(name: "nebelwerfer", const_name: "AXIS.NEBEL", display_name: "Nebelwerfer")

  LightVehicle.create!(name: "motorcycle", const_name: "AXIS.MOTORCYCLE", display_name: "Motorcycle")
  LightVehicle.create!(name: "schwimmwagen_axis", const_name: "AXIS.SCHWIMMWAGEN", display_name: "Schwimmwagen Type 166")
  LightVehicle.create!(name: "halftrack_axis", const_name: "AXIS.AXIS_HT", display_name: "Halftrack",
                       transport_squad_slots: 3, transport_model_slots: 12)
  LightVehicle.create!(name: "flammenwerfer", const_name: "AXIS.FLAMMEN", display_name: "Flammenwerfer")
  LightVehicle.create!(name: "walking_stuka", const_name: "AXIS.STUKA", display_name: "Walking Stuka")
  LightVehicle.create!(name: "puma", const_name: "AXIS.PUMA", display_name: "Puma",
                       upgrade_slots: 2)

  Tank.create!(name: "ostwind", const_name: "AXIS.OSTWIND", display_name: "Ostwind")
  Tank.create!(name: "geschutzwagen", const_name: "AXIS.GESCHUTZWAGEN", display_name: "Geschutzwagen")
  Tank.create!(name: "stug", const_name: "AXIS.STUG", display_name: "StuG", upgrade_slots: 1)
  Tank.create!(name: "p4", const_name: "AXIS.P4", display_name: "Panzer IV", upgrade_slots: 2)
  Tank.create!(name: "panther_axis", const_name: "AXIS.PANTHER", display_name: "Panther")

  ## DEFENSIVE
  Infantry.create!(name: "fortress_pioneers", const_name: "AXIS.GRENS", display_name: "Fortress Pioneers",
                   unitwide_upgrade_slots: 1, upgrade_slots: 1, model_count: 5)

  SupportTeam.create!(name: "officer_def", const_name: "AXIS.OFFICER", display_name: "Officer",
                      upgrade_slots: 1, model_count: 1)

  Emplacement.create!(name: "flak88_def", const_name: "AXIS.FLAK88", display_name: "Flak 36 88mm")

  ## BLITZ
  Infantry.create!(name: "stormtroopers", const_name: "AXIS.STORM_TROOPERS", display_name: "Stormtroopers",
                   unitwide_upgrade_slots: 1, upgrade_slots: 2, model_count: 4)
  Infantry.create!(name: "flammentrupp", const_name: "AXIS.FLAMETRUPP", display_name: "Flammen Trupp",
                   upgrade_slots: 3, model_count: 2)

  SupportTeam.create!(name: "panzer_ace", const_name: "AXIS.OFFICER_BLITZ", display_name: "Panzer Ace",
                      upgrade_slots: 1, model_count: 1)

  LightVehicle.create!(name: "puma_blitz", const_name: "AXIS.PUMA", display_name: "Puma",
                       upgrade_slots: 2, transport_squad_slots: 1, transport_model_slots: 1)

  Tank.create!(name: "ostwind_blitz", const_name: "AXIS.OSTWIND", display_name: "Ostwind",
               transport_squad_slots: 1, transport_model_slots: 1)
  Tank.create!(name: "geschutzwagen_blitz", const_name: "AXIS.GESCHUTZWAGEN", display_name: "Geschutzwagen",
               transport_squad_slots: 1, transport_model_slots: 1)
  Tank.create!(name: "stug_blitz", const_name: "AXIS.STUG", display_name: "StuG", upgrade_slots: 1,
               transport_squad_slots: 1, transport_model_slots: 1)
  Tank.create!(name: "p4_blitz", const_name: "AXIS.P4", display_name: "Panzer IV", upgrade_slots: 2,
               transport_squad_slots: 1, transport_model_slots: 1)
  Tank.create!(name: "panther_blitz", const_name: "AXIS.PANTHER", display_name: "Panther",
               transport_squad_slots: 1, transport_model_slots: 1)

  Tank.create!(name: "stuh", const_name: "AXIS.STUH", display_name: "StuH",
               transport_squad_slots: 1, transport_model_slots: 1)
  Tank.create!(name: "tiger", const_name: "AXIS.TIGER", display_name: "Tiger",
               transport_squad_slots: 1, transport_model_slots: 1)

  ## TERROR
  Infantry.create!(name: "sturmpioneers", const_name: "AXIS.STURMPIONEERS", display_name: "Sturmpioneers",
                   unitwide_upgrade_slots: 1, upgrade_slots: 2, model_count: 5)

  SupportTeam.create!(name: "saboteurs", const_name: "AXIS.SABOTEURS", display_name: "Saboteurs",
                      upgrade_slots: 2, model_count: 2)
  SupportTeam.create!(name: "officer_terror", const_name: "AXIS.OFFICER_TERROR", display_name: "Terror Officer",
                      upgrade_slots: 1, model_count: 1)
  SupportTeam.create!(name: "mortar_terror", const_name: "AXIS.TERROR_MORTAR", display_name: "Terror Mortar",
                      model_count: 3)

  Tank.create!(name: "king_tiger", const_name: "AXIS.KINGTIGER", display_name: "King Tiger")

  Emplacement.create!(name: "lefh", const_name: "AXIS.TERROR_HOWI", display_name: "leFH 18 Airburst")

  #################################################################################
  ################################## Panzer Elite #################################
  ## Common
  Infantry.create!(name: "panzer_grenadiers", const_name: "PE.PANZER_GRENS", display_name: "Panzer Grenadiers",
                   unitwide_upgrade_slots: 1, upgrade_slots: 1, model_count: 3)
  Infantry.create!(name: "assault_grenadiers", const_name: "PE.ASSAULT_GRENS", display_name: "Assault Grenadier",
                   unitwide_upgrade_slots: 1, upgrade_slots: 4, model_count: 3)
  Infantry.create!(name: "tank_busters", const_name: "PE.TANK_BUSTERS", display_name: "Tank Busters",
                   unitwide_upgrade_slots: 1, upgrade_slots: 4, model_count: 3)

  LightVehicle.create!(name: "infantry_halftrack", const_name: "PE.INFANTRY_HT", display_name: "Infantry Halftrack",
                       upgrade_slots: 1, transport_squad_slots: 2, transport_model_slots: 8)
  LightVehicle.create!(name: "mortar_halftrack", const_name: "PE.MORTAR_HT", display_name: "Mortar Halftrack", upgrade_slots: 2)
  LightVehicle.create!(name: "vampire_halftrack", const_name: "PE.VAMPIRE", display_name: "Vampire Halftrack")
  LightVehicle.create!(name: "medic_halftrack", const_name: "PE.MUNITIONS_HT", display_name: "Medic Halftrack")
  LightVehicle.create!(name: "light_at_halftrack", const_name: "PE.AT_HT", display_name: "Light AT Halftrack")
  LightVehicle.create!(name: "scout_car", const_name: "PE.SCOUTCAR", display_name: "Scout Car", upgrade_slots: 1)
  LightVehicle.create!(name: "armored_car", const_name: "PE.ARMOREDCAR", display_name: "Armored Car")

  Tank.create!(name: "marder", const_name: "PE.MARDER", display_name: "Marder III")
  Tank.create!(name: "hotchkiss", const_name: "PE.HOTCHKISS", display_name: "Hotchkiss")
  Tank.create!(name: "p4_ist", const_name: "PE.P4", display_name: "Panzer IV IST", upgrade_slots: 2)
  Tank.create!(name: "panther_pe", const_name: "PE.PANTHER", display_name: "Panther", upgrade_slots: 2)
  Tank.create!(name: "bergetiger", const_name: "PE.BERGETIGER", display_name: "Bergetiger")

  ## SE
  Infantry.create!(name: "ostfront_veterans", const_name: "PE.OST_GREN", display_name: "Ostfront Veterans",
                   unitwide_upgrade_slots: 1, upgrade_slots: 1, model_count: 5)

  LightVehicle.create!(name: "kettenkrad_se", const_name: "PE.KETTENRAD", display_name: "Scorched Earth Kettengrad")
  LightVehicle.create!(name: "schwimmwagen_se", const_name: "PE.SCHWIMMWAGEN", display_name: "Scorched Earth Schwimmwagon")

  Tank.create!(name: "stup", const_name: "PE.STUP", display_name: "StuP IV")
  Tank.create!(name: "hummel", const_name: "PE.HUMMEL", display_name: "Hummel")
  Tank.create!(name: "flammen_hotchkiss", const_name: "PE.FLAME_HOTCH", display_name: "Flammen Hotchkiss")

  ## Luft
  Infantry.create!(name: "falls", const_name: "PE.FALLSHIRMJAGERS", display_name: "Fallshirmjäger",
                   unitwide_upgrade_slots: 1, upgrade_slots: 1, model_count: 4)
  Infantry.create!(name: "gebirgs", const_name: "PE.FSJ_SCOUT", display_name: "Gebirgsjäger",
                   unitwide_upgrade_slots: 1, upgrade_slots: 1, model_count: 3)
  Infantry.create!(name: "luft_infantry", const_name: "PE.LUFTWAFFE", display_name: "Luftwaffe Infantry",
                   unitwide_upgrade_slots: 1, upgrade_slots: 1, model_count: 5)
  Infantry.create!(name: "crete_vets", const_name: "PE.FSJ_AT", display_name: "Crete Veterans",
                   unitwide_upgrade_slots: 1, upgrade_slots: 1, model_count: 5)

  SupportTeam.create!(name: "pak40", const_name: "PE.PANZER_ATG", display_name: "Pak 40")

  LightVehicle.create!(name: "kettenkrad_luft", const_name: "PE.KETTENRAD_3POP", display_name: "Luftwaffe Kettengrad")
  LightVehicle.create!(name: "schwimmwagen_luft", const_name: "PE.SCHWIMMWAGEN", display_name: "Luftwaffe Schwimmwagon")

  Tank.create!(name: "wirbelwind", const_name: "PE.WIRBELWIND", display_name: "Wirbelwind")

  Emplacement.create!(name: "flakvierling_38", const_name: "PE.FLAKVIERLING", display_name: "Flakvierling 38 20mm")
  Emplacement.create!(name: "flak88_luft", const_name: "PE.FLAK", display_name: "Flak 36 88mm")

  ## TH
  LightVehicle.create!(name: "kettenkrad_th", const_name: "PE.KETTENRAD", display_name: "Tank Hunters Kettengrad")
  LightVehicle.create!(name: "schwimmwagen_th", const_name: "PE.SCHWIMMWAGEN", display_name: "Tank Hunters Schwimmwagon")

  Tank.create!(name: "hetzer", const_name: "PE.HETZER", display_name: "Hetzer")
  Tank.create!(name: "jagdpanther", const_name: "PE.JAGDPANTHER", display_name: "Jagdpanther")
  Tank.create!(name: "nashorn", const_name: "PE.NASHORN", display_name: "Nashorn")
  Tank.create!(name: "stug_ace_pe", const_name: "PE.STUG_ACE", display_name: "StuG Ace")

end
