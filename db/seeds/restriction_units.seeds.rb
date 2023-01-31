after :restrictions do
  # Create RestrictionUnits to associate Units with Restrictions and their costs per restriction
  # This associates Units with a Faction, Doctrine, or Unlock, and allows them to be priced separately
  # For example, a Riflemen unit in the Infantry doctrine can have different pricing and resupply than the
  # generic American faction Riflemen unit

  war_ruleset = Ruleset.find_by_name("war")

  #################################################################################
  ################################### Americans ###################################
  americans = Faction.find_by_name("americans")
  american_restriction = Restriction.find_by_faction_id(americans.id)

  ## Common
  riflemen = Infantry.find_by_name("riflemen")
  EnabledUnit.create!(restriction: american_restriction, unit: riflemen, ruleset: war_ruleset,
                      man: 210, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)
  engineers = Infantry.find_by_name("engineers")
  EnabledUnit.create!(restriction: american_restriction, unit: engineers, ruleset: war_ruleset,
                      man: 110, mun: 0, fuel: 0, pop: 3, resupply: 10, resupply_max: 15, company_max: 15, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 2)

  sniper_allied = SupportTeam.find_by_name("sniper_allied")
  EnabledUnit.create!(restriction: american_restriction, unit: sniper_allied, ruleset: war_ruleset,
                      man: 580, mun: 150, fuel: 0, pop: 8, resupply: 1, resupply_max: 1, company_max: 3, priority: 1)
  _30cal_hmg = SupportTeam.find_by_name("30cal_hmg")
  EnabledUnit.create!(restriction: american_restriction, unit: _30cal_hmg, ruleset: war_ruleset,
                      man: 270, mun: 40, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  mortar_allied = SupportTeam.find_by_name("mortar_allied")
  EnabledUnit.create!(restriction: american_restriction, unit: mortar_allied, ruleset: war_ruleset,
                      man: 400, mun: 50, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  _57mm_atg = SupportTeam.find_by_name("57mm_atg")
  EnabledUnit.create!(restriction: american_restriction, unit: _57mm_atg, ruleset: war_ruleset,
                      man: 450, mun: 130, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 8, priority: 1,
                      upgrade_slots: 1)

  jeep = LightVehicle.find_by_name("jeep")
  EnabledUnit.create!(restriction: american_restriction, unit: jeep, ruleset: war_ruleset,
                      man: 110, mun: 0, fuel: 10, pop: 2, resupply: 10, resupply_max: 10, company_max: 20, priority: 1)
  halftrack_allied = LightVehicle.find_by_name("halftrack_allied")
  EnabledUnit.create!(restriction: american_restriction, unit: halftrack_allied, ruleset: war_ruleset,
                      man: 210, mun: 0, fuel: 10, pop: 3, resupply: 10, resupply_max: 12, company_max: 12, priority: 1,
                      upgrade_slots: 1)
  quad_halftrack = LightVehicle.find_by_name("quad_halftrack")
  EnabledUnit.create!(restriction: american_restriction, unit: quad_halftrack, ruleset: war_ruleset,
                      man: 250, mun: 0, fuel: 80, pop: 6, resupply: 3, resupply_max: 6, company_max: 9, priority: 1)
  greyhound = LightVehicle.find_by_name("greyhound")
  EnabledUnit.create!(restriction: american_restriction, unit: greyhound, ruleset: war_ruleset,
                      man: 180, mun: 0, fuel: 60, pop: 7, resupply: 4, resupply_max: 8, company_max: 8, priority: 1,
                      upgrade_slots: 2)
  t17 = LightVehicle.find_by_name("t17")
  EnabledUnit.create!(restriction: american_restriction, unit: t17, ruleset: war_ruleset,
                      man: 220, mun: 0, fuel: 70, pop: 7, resupply: 4, resupply_max: 8, company_max: 8, priority: 1,
                      upgrade_slots: 2)

  sherman = Tank.find_by_name("sherman")
  EnabledUnit.create!(restriction: american_restriction, unit: sherman, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 300, pop: 12, resupply: 4, resupply_max: 8, company_max: 8, priority: 1,
                      upgrade_slots: 2)
  sherman_croc = Tank.find_by_name("sherman_croc")
  EnabledUnit.create!(restriction: american_restriction, unit: sherman_croc, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 230, pop: 10, resupply: 3, resupply_max: 6, company_max: 6, priority: 1,
                      upgrade_slots: 2)
  m10 = Tank.find_by_name("m10")
  EnabledUnit.create!(restriction: american_restriction, unit: m10, ruleset: war_ruleset,
                      man: 300, mun: 0, fuel: 240, pop: 9, resupply: 3, resupply_max: 6, company_max: 8, priority: 1,
                      upgrade_slots: 1)
  m18 = Tank.find_by_name("m18")
  EnabledUnit.create!(restriction: american_restriction, unit: m18, ruleset: war_ruleset,
                      man: 300, mun: 0, fuel: 240, pop: 9, resupply: 3, resupply_max: 6, company_max: 8, priority: 1,
                      upgrade_slots: 1)

  ## Infantry
  infantry = Doctrine.find_by_name("infantry")
  infantry_restriction = Restriction.find_by_doctrine_id(infantry.id)

  rangers = Infantry.find_by_name("rangers")
  EnabledUnit.create!(restriction: infantry_restriction, unit: rangers, ruleset: war_ruleset,
                      man: 300, mun: 90, fuel: 0, pop: 6, resupply: 2, resupply_max: 6, company_max: 10, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)
  ambush_riflemen = Infantry.find_by_name("ambush_riflemen")
  EnabledUnit.create!(restriction: infantry_restriction, unit: ambush_riflemen, ruleset: war_ruleset,
                      man: 150, mun: 0, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 8, priority: 1,
                      upgrade_slots: 1)

  spotter = SupportTeam.find_by_name("spotter")
  EnabledUnit.create!(restriction: infantry_restriction, unit: spotter, ruleset: war_ruleset,
                      man: 150, mun: 20, fuel: 0, pop: 3, resupply: 1, resupply_max: 2, company_max: 3, priority: 1,
                      upgrade_slots: 1)
  officer_infantry = SupportTeam.find_by_name("officer_infantry")
  EnabledUnit.create!(restriction: infantry_restriction, unit: officer_infantry, ruleset: war_ruleset,
                      man: 280, mun: 70, fuel: 0, pop: 4, resupply: 1, resupply_max: 1, company_max: 1, priority: 1,
                      upgrade_slots: 1)

  jumbo = Tank.find_by_name("jumbo")
  EnabledUnit.create!(restriction: infantry_restriction, unit: jumbo, ruleset: war_ruleset,
                      man: 500, mun: 0, fuel: 450, pop: 14, resupply: 1, resupply_max: 2, company_max: 2, priority: 1,
                      upgrade_slots: 2)

  howitzer = Emplacement.find_by_name("howitzer")
  EnabledUnit.create!(restriction: infantry_restriction, unit: howitzer, ruleset: war_ruleset,
                      man: 350, mun: 0, fuel: 180, pop: 8, resupply: 2, resupply_max: 4, company_max: 4, priority: 1,
                      upgrade_slots: 0)


  ## Airborne
  airborne_doc = Doctrine.find_by_name("airborne")
  airborne_restriction = Restriction.find_by_doctrine_id(airborne_doc.id)

  airborne = Infantry.find_by_name("airborne")
  EnabledUnit.create!(restriction: airborne_restriction, unit: airborne, ruleset: war_ruleset,
                      man: 300, mun: 0, fuel: 0, pop: 6, resupply: 4, resupply_max: 10, company_max: 20, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 7)
  assault_airborne = Infantry.find_by_name("assault_airborne")
  EnabledUnit.create!(restriction: airborne_restriction, unit: assault_airborne, ruleset: war_ruleset,
                      man: 300, mun: 0, fuel: 0, pop: 6, resupply: 2, resupply_max: 4, company_max: 6, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 4)

  airborne_hmg = SupportTeam.find_by_name("airborne_hmg")
  EnabledUnit.create!(restriction: airborne_restriction, unit: airborne_hmg, ruleset: war_ruleset,
                      man: 300, mun: 40, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1,
                      upgrade_slots: 1)
  airborne_mortar = SupportTeam.find_by_name("airborne_mortar")
  EnabledUnit.create!(restriction: airborne_restriction, unit: airborne_mortar, ruleset: war_ruleset,
                      man: 430, mun: 50, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1,
                      upgrade_slots: 1)
  airborne_atg = SupportTeam.find_by_name("airborne_atg")
  EnabledUnit.create!(restriction: airborne_restriction, unit: airborne_atg, ruleset: war_ruleset,
                      man: 480, mun: 130, fuel: 0, pop: 5, resupply: 4, resupply_max: 6, company_max: 6, priority: 1,
                      upgrade_slots: 1)
  airborne_sniper = SupportTeam.find_by_name("airborne_sniper")
  EnabledUnit.create!(restriction: airborne_restriction, unit: airborne_sniper, ruleset: war_ruleset,
                      man: 600, mun: 150, fuel: 0, pop: 8, resupply: 1, resupply_max: 1, company_max: 3, priority: 1,
                      upgrade_slots: 1)

  chaffee = Tank.find_by_name("chaffee")
  EnabledUnit.create!(restriction: airborne_restriction, unit: chaffee, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 180, pop: 10, resupply: 1, resupply_max: 1, company_max: 1, priority: 1,
                      upgrade_slots: 2)

  ## Armor
  armor = Doctrine.find_by_name("armor")
  armor_restriction = Restriction.find_by_doctrine_id(armor.id)

  mech_inf = Infantry.find_by_name("mech_inf")
  EnabledUnit.create!(restriction: armor_restriction, unit: mech_inf, ruleset: war_ruleset,
                      man: 240, mun: 0, fuel: 0, pop: 4, resupply: 4, resupply_max: 8, company_max: 10, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)

  sherman_105 = Tank.find_by_name("sherman_105")
  EnabledUnit.create!(restriction: armor_restriction, unit: sherman_105, ruleset: war_ruleset,
                      man: 340, mun: 0, fuel: 280, pop: 9, resupply: 1, resupply_max: 2, company_max: 3, priority: 1,
                      upgrade_slots: 2)
  calliope = Tank.find_by_name("calliope")
  EnabledUnit.create!(restriction: armor_restriction, unit: calliope, ruleset: war_ruleset,
                      man: 400, mun: 0, fuel: 450, pop: 13, resupply: 1, resupply_max: 2, company_max: 3, priority: 1,
                      upgrade_slots: 2)
  easy_eight = Tank.find_by_name("easy_eight")
  EnabledUnit.create!(restriction: armor_restriction, unit: easy_eight, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 340, pop: 11, resupply: 1, resupply_max: 2, company_max: 2, priority: 1,
                      upgrade_slots: 2)
  jackson = Tank.find_by_name("jackson")
  EnabledUnit.create!(restriction: armor_restriction, unit: jackson, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 420, pop: 13, resupply: 1, resupply_max: 1, company_max: 1, priority: 1,
                      upgrade_slots: 0)
  pershing = Tank.find_by_name("pershing")
  EnabledUnit.create!(restriction: armor_restriction, unit: pershing, ruleset: war_ruleset,
                      man: 650, mun: 0, fuel: 650, pop: 16, resupply: 1, resupply_max: 2, company_max: 3, priority: 1,
                      upgrade_slots: 1)

  #################################################################################
  #################################### British ####################################
  british = Faction.find_by_name("british")
  british_restriction = Restriction.find_by_faction_id(british.id)

  ## Common
  infantry_section = Infantry.find_by_name("infantry_section")
  EnabledUnit.create!(restriction: british_restriction, unit: infantry_section, ruleset: war_ruleset,
                      man: 220, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1,
                      unitwide_upgrade_slots: 0, upgrade_slots: 1)
  recon_section = Infantry.find_by_name("recon_section")
  EnabledUnit.create!(restriction: british_restriction, unit: recon_section, ruleset: war_ruleset,
                      man: 200, mun: 0, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 10, priority: 1,
                      unitwide_upgrade_slots: 0, upgrade_slots: 1)
  sappers = Infantry.find_by_name("sappers")
  EnabledUnit.create!(restriction: british_restriction, unit: sappers, ruleset: war_ruleset,
                      man: 220, mun: 0, fuel: 0, pop: 4, resupply: 10, resupply_max: 15, company_max: 15, priority: 1,
                      unitwide_upgrade_slots: 0, upgrade_slots: 1)
  expert_sappers = Infantry.find_by_name("expert_sappers")
  EnabledUnit.create!(restriction: british_restriction, unit: expert_sappers, ruleset: war_ruleset,
                      man: 150, mun: 120, fuel: 0, pop: 3, resupply: 2, resupply_max: 4, company_max: 4, priority: 1,
                      unitwide_upgrade_slots: 0, upgrade_slots: 1)

  lt = SupportTeam.find_by_name("lt")
  EnabledUnit.create!(restriction: british_restriction, unit: lt, ruleset: war_ruleset,
                      man: 260, mun: 45, fuel: 0, pop: 2, resupply: 3, resupply_max: 6, company_max: 6, priority: 1,
                      upgrade_slots: 1)
  captain = SupportTeam.find_by_name("captain")
  EnabledUnit.create!(restriction: british_restriction, unit: captain, ruleset: war_ruleset,
                      man: 300, mun: 70, fuel: 0, pop: 3, resupply: 1, resupply_max: 1, company_max: 1, priority: 1,
                      upgrade_slots: 1)
  mortar_british = SupportTeam.find_by_name("mortar_british")
  EnabledUnit.create!(restriction: british_restriction, unit: mortar_british, ruleset: war_ruleset,
                      man: 400, mun: 50, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  vickers_hmg = SupportTeam.find_by_name("vickers_hmg")
  EnabledUnit.create!(restriction: british_restriction, unit: vickers_hmg, ruleset: war_ruleset,
                      man: 270, mun: 30, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  _17pdr = SupportTeam.find_by_name("17pdr")
  EnabledUnit.create!(restriction: british_restriction, unit: _17pdr, ruleset: war_ruleset,
                      man: 450, mun: 160, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)

  universal_carrier = LightVehicle.find_by_name("universal_carrier")
  EnabledUnit.create!(restriction: british_restriction, unit: universal_carrier, ruleset: war_ruleset,
                      man: 150, mun: 0, fuel: 10, pop: 2, resupply: 10, resupply_max: 15, company_max: 15, priority: 1,
                      upgrade_slots: 1)
  bren_carrier = LightVehicle.find_by_name("bren_carrier")
  EnabledUnit.create!(restriction: british_restriction, unit: bren_carrier, ruleset: war_ruleset,
                      man: 220, mun: 0, fuel: 30, pop: 3, resupply: 4, resupply_max: 12, company_max: 12, priority: 1,
                      upgrade_slots: 1)
  staghound = LightVehicle.find_by_name("staghound")
  EnabledUnit.create!(restriction: british_restriction, unit: staghound, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 120, pop: 9, resupply: 1, resupply_max: 3, company_max: 6, priority: 1)

  stuart = Tank.find_by_name("stuart")
  EnabledUnit.create!(restriction: british_restriction, unit: stuart, ruleset: war_ruleset,
                      man: 280, mun: 0, fuel: 80, pop: 7, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  cromwell = Tank.find_by_name("cromwell")
  EnabledUnit.create!(restriction: british_restriction, unit: cromwell, ruleset: war_ruleset,
                      man: 300, mun: 0, fuel: 250, pop: 10, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)
  cct = Tank.find_by_name("cct")
  EnabledUnit.create!(restriction: british_restriction, unit: cct, ruleset: war_ruleset,
                      man: 250, mun: 0, fuel: 120, pop: 3, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  kangaroo = Tank.find_by_name("kangaroo")
  EnabledUnit.create!(restriction: british_restriction, unit: kangaroo, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 110, pop: 4, resupply: 2, resupply_max: 4, company_max: 8, priority: 1)
  firefly = Tank.find_by_name("firefly")
  EnabledUnit.create!(restriction: british_restriction, unit: firefly, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 380, pop: 11, resupply: 1, resupply_max: 3, company_max: 4, priority: 1)

  _25pdr = Emplacement.find_by_name("25pdr")
  EnabledUnit.create!(restriction: british_restriction, unit: _25pdr, ruleset: war_ruleset,
                      man: 250, mun: 0, fuel: 110, pop: 7, resupply: 2, resupply_max: 4, company_max: 4, priority: 1)
  bofors = Emplacement.find_by_name("bofors")
  EnabledUnit.create!(restriction: british_restriction, unit: bofors, ruleset: war_ruleset,
                      man: 350, mun: 0, fuel: 60, pop: 3, resupply: 3, resupply_max: 4, company_max: 6, priority: 1)

  ## RCA
  rca = Doctrine.find_by_name("canadians")
  rca_restriction = Restriction.find_by_doctrine_id(rca.id)

  # Need to block infantry_section as they are replaced by canadian_section
  DisabledUnit.create!(restriction: rca_restriction, unit: infantry_section, ruleset: war_ruleset, priority: 1)

  canadian_section = Infantry.find_by_name("canadian_section")
  EnabledUnit.create!(restriction: rca_restriction, unit: canadian_section, ruleset: war_ruleset,
                      man: 220, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1,
                      unitwide_upgrade_slots: 0, upgrade_slots: 1)
  ssf = Infantry.find_by_name("ssf")
  EnabledUnit.create!(restriction: rca_restriction, unit: ssf, ruleset: war_ruleset,
                      man: 260, mun: 30, fuel: 0, pop: 5, resupply: 1, resupply_max: 3, company_max: 4, priority: 1,
                      unitwide_upgrade_slots: 0, upgrade_slots: 1)


  stuart_recce = Tank.find_by_name("stuart_recce")
  EnabledUnit.create!(restriction: rca_restriction, unit: stuart_recce, ruleset: war_ruleset,
                      man: 280, mun: 0, fuel: 50, pop: 4, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  comet = Tank.find_by_name("comet")
  EnabledUnit.create!(restriction: rca_restriction, unit: comet, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 320, pop: 12, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)
  priest = Tank.find_by_name("priest")
  EnabledUnit.create!(restriction: rca_restriction, unit: priest, ruleset: war_ruleset,
                      man: 450, mun: 0, fuel: 260, pop: 9, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)

  ## Engineers
  engineers = Doctrine.find_by_name("engineers")
  engineers_restriction = Restriction.find_by_doctrine_id(engineers.id)

  churchill = Tank.find_by_name("churchill")
  EnabledUnit.create!(restriction: engineers_restriction, unit: churchill, ruleset: war_ruleset,
                      man: 300, mun: 0, fuel: 250, pop: 10, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  churchill_avre = Tank.find_by_name("churchill_avre")
  EnabledUnit.create!(restriction: engineers_restriction, unit: churchill_avre, ruleset: war_ruleset,
                      man: 400, mun: 0, fuel: 300, pop: 10, resupply: 1, resupply_max: 3, company_max: 4, priority: 1)
  churchill_croc = Tank.find_by_name("churchill_croc")
  EnabledUnit.create!(restriction: engineers_restriction, unit: churchill_croc, ruleset: war_ruleset,
                      man: 600, mun: 0, fuel: 500, pop: 15, resupply: 1, resupply_max: 3, company_max: 4, priority: 1)
  churchill_cct = Tank.find_by_name("churchill_cct")
  EnabledUnit.create!(restriction: engineers_restriction, unit: churchill_cct, ruleset: war_ruleset,
                      man: 300, mun: 0, fuel: 140, pop: 4, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  stuart_flame = Tank.find_by_name("stuart_flame")
  EnabledUnit.create!(restriction: engineers_restriction, unit: stuart_flame, ruleset: war_ruleset,
                      man: 260, mun: 0, fuel: 60, pop: 7, resupply: 2, resupply_max: 4, company_max: 4, priority: 1)

  ## Commandos
  commandos = Doctrine.find_by_name("commandos")
  commandos_restriction = Restriction.find_by_doctrine_id(commandos.id)

  commandos = Infantry.find_by_name("commandos")
  EnabledUnit.create!(restriction: commandos_restriction, unit: commandos, ruleset: war_ruleset,
                      man: 250, mun: 130, fuel: 0, pop: 6, resupply: 2, resupply_max: 6, company_max: 8, priority: 1,
                      unitwide_upgrade_slots: 0, upgrade_slots: 6)
  piat_commandos = Infantry.find_by_name("piat_commandos")
  EnabledUnit.create!(restriction: commandos_restriction, unit: piat_commandos, ruleset: war_ruleset,
                      man: 200, mun: 120, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 8, priority: 1,
                      unitwide_upgrade_slots: 0, upgrade_slots: 1)
  polish_commandos = Infantry.find_by_name("polish_commandos")
  EnabledUnit.create!(restriction: commandos_restriction, unit: polish_commandos, ruleset: war_ruleset,
                      man: 250, mun: 0, fuel: 0, pop: 7, resupply: 1, resupply_max: 1, company_max: 1, priority: 1,
                      unitwide_upgrade_slots: 0, upgrade_slots: 1)

  commando_2pdr = SupportTeam.find_by_name("commando_2pdr")
  EnabledUnit.create!(restriction: commandos_restriction, unit: commando_2pdr, ruleset: war_ruleset,
                      man: 350, mun: 120, fuel: 0, pop: 4, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)
  commando_hmg = SupportTeam.find_by_name("commando_hmg")
  EnabledUnit.create!(restriction: commandos_restriction, unit: commando_hmg, ruleset: war_ruleset,
                      man: 300, mun: 40, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  commando_mortar = SupportTeam.find_by_name("commando_mortar")
  EnabledUnit.create!(restriction: commandos_restriction, unit: commando_mortar, ruleset: war_ruleset,
                      man: 430, mun: 40, fuel: 0, pop: 4, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)

  tetrarch = LightVehicle.find_by_name("tetrarch")
  EnabledUnit.create!(restriction: commandos_restriction, unit: tetrarch, ruleset: war_ruleset,
                      man: 280, mun: 0, fuel: 80, pop: 8, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  sas_jeep = LightVehicle.find_by_name("sas_jeep")
  EnabledUnit.create!(restriction: commandos_restriction, unit: sas_jeep, ruleset: war_ruleset,
                      man: 240, mun: 0, fuel: 20, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)

  infantry_glider = Glider.find_by_name("infantry_glider")
  EnabledUnit.create!(restriction: commandos_restriction, unit: infantry_glider, ruleset: war_ruleset,
                      man: 50, mun: 0, fuel: 0, pop: 0, resupply: 10, resupply_max: 10, company_max: 10, priority: 1)
  armor_glider = Glider.find_by_name("armor_glider")
  EnabledUnit.create!(restriction: commandos_restriction, unit: armor_glider, ruleset: war_ruleset,
                      man: 100, mun: 0, fuel: 10, pop: 0, resupply: 10, resupply_max: 10, company_max: 10, priority: 1)

  #################################################################################
  ################################### Wehrmacht ###################################
  wehrmacht = Faction.find_by_name("wehrmacht")
  wehrmacht_restriction = Restriction.find_by_faction_id(wehrmacht.id)

  ## Common
  volksgrenadiers = Infantry.find_by_name("volksgrenadiers")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: volksgrenadiers, ruleset: war_ruleset,
                      man: 190, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 3)
  grenadiers = Infantry.find_by_name("grenadiers")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: grenadiers, ruleset: war_ruleset,
                      man: 240, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 2)
  pioneers = Infantry.find_by_name("pioneers")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: pioneers, ruleset: war_ruleset,
                      man: 110, mun: 0, fuel: 0, pop: 2, resupply: 10, resupply_max: 15, company_max: 15, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 5)
  kch = Infantry.find_by_name("kch")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: kch, ruleset: war_ruleset,
                      man: 300, mun: 120, fuel: 0, pop: 6, resupply: 2, resupply_max: 4, company_max: 6, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)

  medic = SupportTeam.find_by_name("medic")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: medic, ruleset: war_ruleset,
                      man: 180, mun: 100, fuel: 0, pop: 2, resupply: 1, resupply_max: 2, company_max: 2, priority: 1,
                      upgrade_slots: 1)
  mg42 = SupportTeam.find_by_name("mg42")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: mg42, ruleset: war_ruleset,
                      man: 270, mun: 50, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1,
                      upgrade_slots: 3)
  mortar_axis = SupportTeam.find_by_name("mortar_axis")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: mortar_axis, ruleset: war_ruleset,
                      man: 500, mun: 70, fuel: 0, pop: 4, resupply: 3, resupply_max: 6, company_max: 6, priority: 1,
                      upgrade_slots: 3)
  pak38 = SupportTeam.find_by_name("pak38")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: pak38, ruleset: war_ruleset,
                      man: 500, mun: 160, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)
  sniper_axis = SupportTeam.find_by_name("sniper_axis")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: sniper_axis, ruleset: war_ruleset,
                      man: 520, mun: 135, fuel: 0, pop: 8, resupply: 1, resupply_max: 1, company_max: 3, priority: 1)
  nebelwerfer = SupportTeam.find_by_name("nebelwerfer")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: nebelwerfer, ruleset: war_ruleset,
                      man: 350, mun: 0, fuel: 150, pop: 7, resupply: 2, resupply_max: 4, company_max: 5, priority: 1)

  motorcycle = LightVehicle.find_by_name("motorcycle")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: motorcycle, ruleset: war_ruleset,
                      man: 110, mun: 0, fuel: 10, pop: 2, resupply: 10, resupply_max: 10, company_max: 20, priority: 1)
  schwimmwagen_axis = LightVehicle.find_by_name("schwimmwagen_axis")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: schwimmwagen_axis, ruleset: war_ruleset,
                      man: 140, mun: 0, fuel: 10, pop: 2, resupply: 4, resupply_max: 8, company_max: 10, priority: 1)
  halftrack_axis = LightVehicle.find_by_name("halftrack_axis")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: halftrack_axis, ruleset: war_ruleset,
                      man: 200, mun: 0, fuel: 10, pop: 2, resupply: 10, resupply_max: 12, company_max: 12, priority: 1)
  flammenwerfer = LightVehicle.find_by_name("flammenwerfer")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: flammenwerfer, ruleset: war_ruleset,
                      man: 210, mun: 0, fuel: 50, pop: 5, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  walking_stuka = LightVehicle.find_by_name("walking_stuka")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: walking_stuka, ruleset: war_ruleset,
                      man: 250, mun: 0, fuel: 225, pop: 7, resupply: 2, resupply_max: 4, company_max: 4, priority: 1)
  puma = LightVehicle.find_by_name("puma")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: puma, ruleset: war_ruleset,
                      man: 280, mun: 0, fuel: 70, pop: 7, resupply: 4, resupply_max: 8, company_max: 8, priority: 1,
                      upgrade_slots: 2)

  ostwind = Tank.find_by_name("ostwind")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: ostwind, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 230, pop: 10, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  geschutzwagen = Tank.find_by_name("geschutzwagen")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: geschutzwagen, ruleset: war_ruleset,
                      man: 270, mun: 0, fuel: 180, pop: 7, resupply: 3, resupply_max: 6, company_max: 10, priority: 1)
  stug = Tank.find_by_name("stug")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: stug, ruleset: war_ruleset,
                      man: 280, mun: 0, fuel: 170, pop: 8, resupply: 3, resupply_max: 6, company_max: 10, priority: 1,
                      upgrade_slots: 1)
  p4 = Tank.find_by_name("p4")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: p4, ruleset: war_ruleset,
                      man: 350, mun: 0, fuel: 300, pop: 12, resupply: 4, resupply_max: 8, company_max: 8, priority: 1,
                      upgrade_slots: 2)
  panther_axis = Tank.find_by_name("panther_axis")
  EnabledUnit.create!(restriction: wehrmacht_restriction, unit: panther_axis, ruleset: war_ruleset,
                      man: 600, mun: 0, fuel: 520, pop: 15, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)

  ## DEFENSIVE
  defensive = Doctrine.find_by_name("defensive")
  defensive_restriction = Restriction.find_by_doctrine_id(defensive.id)


  fortress_pioneers = Infantry.find_by_name("fortress_pioneers")
  EnabledUnit.create!(restriction: defensive_restriction, unit: fortress_pioneers, ruleset: war_ruleset,
                      man: 230, mun: 0, fuel: 0, pop: 5, resupply: 1, resupply_max: 1, company_max: 1, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)

  officer_def = SupportTeam.find_by_name("officer_def")
  EnabledUnit.create!(restriction: defensive_restriction, unit: officer_def, ruleset: war_ruleset,
                      man: 280, mun: 100, fuel: 0, pop: 3, resupply: 1, resupply_max: 3, company_max: 3, priority: 1,
                      upgrade_slots: 1)

  flak88_def = Emplacement.find_by_name("flak88_def")
  EnabledUnit.create!(restriction: defensive_restriction, unit: flak88_def, ruleset: war_ruleset,
                      man: 550, mun: 0, fuel: 250, pop: 8, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)


  ## BLITZ
  blitz = Doctrine.find_by_name("blitz")
  blitz_restriction = Restriction.find_by_doctrine_id(blitz.id)

  stormtroopers = Infantry.find_by_name("stormtroopers")
  EnabledUnit.create!(restriction: blitz_restriction, unit: stormtroopers, ruleset: war_ruleset,
                      man: 300, mun: 0, fuel: 0, pop: 6, resupply: 2, resupply_max: 6, company_max: 10, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 2)
  flammentrupp = Infantry.find_by_name("flammentrupp")
  EnabledUnit.create!(restriction: blitz_restriction, unit: flammentrupp, ruleset: war_ruleset,
                      man: 150, mun: 100, fuel: 0, pop: 3, resupply: 1, resupply_max: 1, company_max: 1, priority: 1,
                      upgrade_slots: 3)

  panzer_ace = SupportTeam.find_by_name("panzer_ace")
  EnabledUnit.create!(restriction: blitz_restriction, unit: panzer_ace, ruleset: war_ruleset,
                      man: 280, mun: 80, fuel: 0, pop: 2, resupply: 1, resupply_max: 1, company_max: 1, priority: 1,
                      upgrade_slots: 1)

  stuh = Tank.find_by_name("stuh")
  EnabledUnit.create!(restriction: blitz_restriction, unit: stuh, ruleset: war_ruleset,
                      man: 320, mun: 0, fuel: 180, pop: 9, resupply: 2, resupply_max: 4, company_max: 6, priority: 1)
  tiger = Tank.find_by_name("tiger")
  EnabledUnit.create!(restriction: blitz_restriction, unit: tiger, ruleset: war_ruleset,
                      man: 725, mun: 0, fuel: 725, pop: 16, resupply: 1, resupply_max: 2, company_max: 3, priority: 1)

  ## TERROR
  terror = Doctrine.find_by_name("terror")
  terror_restriction = Restriction.find_by_doctrine_id(terror.id)

  sturmpioneers = Infantry.find_by_name("sturmpioneers")
  EnabledUnit.create!(restriction: terror_restriction, unit: sturmpioneers, ruleset: war_ruleset,
                      man: 250, mun: 0, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 10, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 2)

  saboteurs = SupportTeam.find_by_name("saboteurs")
  EnabledUnit.create!(restriction: terror_restriction, unit: saboteurs, ruleset: war_ruleset,
                      man: 100, mun: 0, fuel: 0, pop: 4, resupply: 2, resupply_max: 6, company_max: 6, priority: 1,
                      upgrade_slots: 2)
  officer_terror = SupportTeam.find_by_name("officer_terror")
  EnabledUnit.create!(restriction: terror_restriction, unit: officer_terror, ruleset: war_ruleset,
                      man: 280, mun: 100, fuel: 0, pop: 3, resupply: 1, resupply_max: 3, company_max: 3, priority: 1,
                      upgrade_slots: 1)
  mortar_terror = SupportTeam.find_by_name("mortar_terror")
  EnabledUnit.create!(restriction: terror_restriction, unit: mortar_terror, ruleset: war_ruleset,
                      man: 400, mun: 70, fuel: 0, pop: 3, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  king_tiger = Tank.find_by_name("king_tiger")
  EnabledUnit.create!(restriction: terror_restriction, unit: king_tiger, ruleset: war_ruleset,
                      man: 800, mun: 0, fuel: 800, pop: 17, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  lefh = Emplacement.find_by_name("lefh")
  EnabledUnit.create!(restriction: terror_restriction, unit: lefh, ruleset: war_ruleset,
                      man: 350, mun: 0, fuel: 160, pop: 8, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)

  #################################################################################
  ################################## Panzer Elite #################################
  panzer_elite = Faction.find_by_name("panzer_elite")
  panzer_elite_restriction = Restriction.find_by_faction_id(panzer_elite.id)

  ## Common
  panzer_grenadiers = Infantry.find_by_name("panzer_grenadiers")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: panzer_grenadiers, ruleset: war_ruleset,
                      man: 170, mun: 0, fuel: 0, pop: 3, resupply: 99, resupply_max: 100, company_max: 100, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)
  assault_grenadiers = Infantry.find_by_name("assault_grenadiers")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: assault_grenadiers, ruleset: war_ruleset,
                      man: 170, mun: 85, fuel: 0, pop: 3, resupply: 10, resupply_max: 15, company_max: 15, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 4)
  tank_busters = Infantry.find_by_name("tank_busters")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: tank_busters, ruleset: war_ruleset,
                      man: 170, mun: 110, fuel: 0, pop: 3, resupply: 10, resupply_max: 20, company_max: 20, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 4)

  infantry_halftrack = LightVehicle.find_by_name("infantry_halftrack")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: infantry_halftrack, ruleset: war_ruleset,
                      man: 180, mun: 0, fuel: 20, pop: 2, resupply: 10, resupply_max: 15, company_max: 15, priority: 1,
                      upgrade_slots: 1)
  mortar_halftrack = LightVehicle.find_by_name("mortar_halftrack")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: mortar_halftrack, ruleset: war_ruleset,
                      man: 500, mun: 70, fuel: 50, pop: 6, resupply: 2, resupply_max: 4, company_max: 6, priority: 1,
                      upgrade_slots: 2)
  vampire_halftrack = LightVehicle.find_by_name("vampire_halftrack")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: vampire_halftrack, ruleset: war_ruleset,
                      man: 240, mun: 0, fuel: 40, pop: 3, resupply: 2, resupply_max: 4, company_max: 5, priority: 1)
  medic_halftrack = LightVehicle.find_by_name("medic_halftrack")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: medic_halftrack, ruleset: war_ruleset,
                      man: 300, mun: 100, fuel: 50, pop: 4, resupply: 2, resupply_max: 3, company_max: 3, priority: 1)
  light_at_halftrack = LightVehicle.find_by_name("light_at_halftrack")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: light_at_halftrack, ruleset: war_ruleset,
                      man: 230, mun: 75, fuel: 70, pop: 4, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  scout_car = LightVehicle.find_by_name("scout_car")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: scout_car, ruleset: war_ruleset,
                      man: 150, mun: 0, fuel: 20, pop: 2, resupply: 10, resupply_max: 10, company_max: 10, priority: 1,
                      upgrade_slots: 1)
  armored_car = LightVehicle.find_by_name("armored_car")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: armored_car, ruleset: war_ruleset,
                      man: 240, mun: 0, fuel: 50, pop: 5, resupply: 4, resupply_max: 8, company_max: 12, priority: 1)

  marder = Tank.find_by_name("marder")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: marder, ruleset: war_ruleset,
                      man: 270, mun: 0, fuel: 180, pop: 6, resupply: 4, resupply_max: 8, company_max: 10, priority: 1)
  hotchkiss = Tank.find_by_name("hotchkiss")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: hotchkiss, ruleset: war_ruleset,
                      man: 260, mun: 0, fuel: 70, pop: 8, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  p4_ist = Tank.find_by_name("p4_ist")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: p4_ist, ruleset: war_ruleset,
                      man: 350, mun: 0, fuel: 180, pop: 9, resupply: 4, resupply_max: 8, company_max: 8, priority: 1,
                      upgrade_slots: 2)
  panther_pe = Tank.find_by_name("panther_pe")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: panther_pe, ruleset: war_ruleset,
                      man: 600, mun: 0, fuel: 520, pop: 15, resupply: 1, resupply_max: 3, company_max: 3, priority: 1,
                      upgrade_slots: 2)
  bergetiger = Tank.find_by_name("bergetiger")
  EnabledUnit.create!(restriction: panzer_elite_restriction, unit: bergetiger, ruleset: war_ruleset,
                      man: 240, mun: 0, fuel: 180, pop: 4, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)

  ## SE
  scorched_earth = Doctrine.find_by_name("scorched_earth")
  scorched_earth_restriction = Restriction.find_by_doctrine_id(scorched_earth.id)

  ostfront_veterans = Infantry.find_by_name("ostfront_veterans")
  EnabledUnit.create!(restriction: scorched_earth_restriction, unit: ostfront_veterans, ruleset: war_ruleset,
                      man: 300, mun: 0, fuel: 0, pop: 5, resupply: 2, resupply_max: 4, company_max: 6, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)

  kettenkrad_se = LightVehicle.find_by_name("kettenkrad_se")
  EnabledUnit.create!(restriction: scorched_earth_restriction, unit: kettenkrad_se, ruleset: war_ruleset,
                      man: 100, mun: 20, fuel: 5, pop: 2, resupply: 4, resupply_max: 10, company_max: 15, priority: 1)
  schwimmwagen_se = LightVehicle.find_by_name("schwimmwagen_se")
  EnabledUnit.create!(restriction: scorched_earth_restriction, unit: schwimmwagen_se, ruleset: war_ruleset,
                      man: 100, mun: 20, fuel: 5, pop: 2, resupply: 3, resupply_max: 6, company_max: 10, priority: 1)

  stup = Tank.find_by_name("stup")
  EnabledUnit.create!(restriction: scorched_earth_restriction, unit: stup, ruleset: war_ruleset,
                      man: 400, mun: 0, fuel: 300, pop: 11, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)
  hummel = Tank.find_by_name("hummel")
  EnabledUnit.create!(restriction: scorched_earth_restriction, unit: hummel, ruleset: war_ruleset,
                      man: 400, mun: 0, fuel: 240, pop: 10, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)
  flammen_hotchkiss = Tank.find_by_name("flammen_hotchkiss")
  EnabledUnit.create!(restriction: scorched_earth_restriction, unit: flammen_hotchkiss, ruleset: war_ruleset,
                      man: 260, mun: 0, fuel: 90, pop: 7, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  ## Luft
  luftwaffe = Doctrine.find_by_name("luftwaffe")
  luftwaffe_restriction = Restriction.find_by_doctrine_id(luftwaffe.id)

  falls = Infantry.find_by_name("falls")
  EnabledUnit.create!(restriction: luftwaffe_restriction, unit: falls, ruleset: war_ruleset,
                      man: 240, mun: 0, fuel: 0, pop: 4, resupply: 5, resupply_max: 10, company_max: 20, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)
  gebirgs = Infantry.find_by_name("gebirgs")
  EnabledUnit.create!(restriction: luftwaffe_restriction, unit: gebirgs, ruleset: war_ruleset,
                      man: 200, mun: 100, fuel: 0, pop: 4, resupply: 2, resupply_max: 4, company_max: 6, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)
  luft_infantry = Infantry.find_by_name("luft_infantry")
  EnabledUnit.create!(restriction: luftwaffe_restriction, unit: luft_infantry, ruleset: war_ruleset,
                      man: 180, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)
  crete_vets = Infantry.find_by_name("crete_vets")
  EnabledUnit.create!(restriction: luftwaffe_restriction, unit: crete_vets, ruleset: war_ruleset,
                      man: 320, mun: 20, fuel: 0, pop: 6, resupply: 1, resupply_max: 1, company_max: 1, priority: 1,
                      unitwide_upgrade_slots: 1, upgrade_slots: 1)

  pak40 = SupportTeam.find_by_name("pak40")
  EnabledUnit.create!(restriction: luftwaffe_restriction, unit: pak40, ruleset: war_ruleset,
                      man: 450, mun: 160, fuel: 0, pop: 5, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)

  kettenkrad_luft = LightVehicle.find_by_name("kettenkrad_luft")
  EnabledUnit.create!(restriction: luftwaffe_restriction, unit: kettenkrad_luft, ruleset: war_ruleset,
                      man: 150, mun: 20, fuel: 10, pop: 3, resupply: 4, resupply_max: 10, company_max: 15, priority: 1)
  schwimmwagen_luft = LightVehicle.find_by_name("schwimmwagen_luft")
  EnabledUnit.create!(restriction: luftwaffe_restriction, unit: schwimmwagen_luft, ruleset: war_ruleset,
                      man: 100, mun: 0, fuel: 10, pop: 2, resupply: 3, resupply_max: 6, company_max: 10, priority: 1)

  wirbelwind = Tank.find_by_name("wirbelwind")
  EnabledUnit.create!(restriction: luftwaffe_restriction, unit: wirbelwind, ruleset: war_ruleset,
                      man: 280, mun: 0, fuel: 120, pop: 7, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)

  flakvierling_38 = Emplacement.find_by_name("flakvierling_38")
  EnabledUnit.create!(restriction: luftwaffe_restriction, unit: flakvierling_38, ruleset: war_ruleset,
                      man: 250, mun: 0, fuel: 60, pop: 3, resupply: 2, resupply_max: 4, company_max: 6, priority: 1)
  flak88_luft = Emplacement.find_by_name("flak88_luft")
  EnabledUnit.create!(restriction: luftwaffe_restriction, unit: flak88_luft, ruleset: war_ruleset,
                      man: 550, mun: 0, fuel: 250, pop: 8, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)

  ## TH
  tank_hunters = Doctrine.find_by_name("tank_hunters")
  tank_hunters_restriction = Restriction.find_by_doctrine_id(tank_hunters.id)

  kettenkrad_th = LightVehicle.find_by_name("kettenkrad_th")
  EnabledUnit.create!(restriction: tank_hunters_restriction, unit: kettenkrad_th, ruleset: war_ruleset,
                      man: 100, mun: 35, fuel: 5, pop: 2, resupply: 4, resupply_max: 10, company_max: 10, priority: 1)
  schwimmwagen_th = LightVehicle.find_by_name("schwimmwagen_th")
  EnabledUnit.create!(restriction: tank_hunters_restriction, unit: schwimmwagen_th, ruleset: war_ruleset,
                      man: 100, mun: 35, fuel: 5, pop: 2, resupply: 3, resupply_max: 6, company_max: 10, priority: 1)

  hetzer = Tank.find_by_name("hetzer")
  EnabledUnit.create!(restriction: tank_hunters_restriction, unit: hetzer, ruleset: war_ruleset,
                      man: 350, mun: 0, fuel: 200, pop: 9, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  jagdpanther = Tank.find_by_name("jagdpanther")
  EnabledUnit.create!(restriction: tank_hunters_restriction, unit: jagdpanther, ruleset: war_ruleset,
                      man: 1050, mun: 0, fuel: 750, pop: 16, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  nashorn = Tank.find_by_name("nashorn")
  EnabledUnit.create!(restriction: tank_hunters_restriction, unit: nashorn, ruleset: war_ruleset,
                      man: 450, mun: 0, fuel: 400, pop: 13, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)
  stug_ace_pe = Tank.find_by_name("stug_ace_pe")
  EnabledUnit.create!(restriction: tank_hunters_restriction, unit: stug_ace_pe, ruleset: war_ruleset,
                      man: 280, mun: 45, fuel: 230, pop: 10, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

end
