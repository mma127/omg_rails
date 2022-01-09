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
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: riflemen, ruleset: war_ruleset,
                              man: 210, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1)
  engineers = Infantry.find_by_name("engineers")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: engineers, ruleset: war_ruleset,
                              man: 110, mun: 0, fuel: 0, pop: 3, resupply: 10, resupply_max: 15, company_max: 15, priority: 1)

  sniper_allied = SupportTeam.find_by_name("sniper_allied")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: sniper_allied, ruleset: war_ruleset,
                              man: 580, mun: 150, fuel: 0, pop: 8, resupply: 1, resupply_max: 1, company_max: 3, priority: 1)
  _30cal_hmg = SupportTeam.find_by_name("30cal_hmg")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: _30cal_hmg, ruleset: war_ruleset,
                              man: 270, mun: 40, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  mortar_allied = SupportTeam.find_by_name("mortar_allied")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: mortar_allied, ruleset: war_ruleset,
                              man: 400, mun: 50, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  _57mm_atg = SupportTeam.find_by_name("57mm_atg")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: _57mm_atg, ruleset: war_ruleset,
                              man: 450, mun: 130, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)

  jeep = LightVehicle.find_by_name("jeep")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: jeep, ruleset: war_ruleset,
                              man: 110, mun: 0, fuel: 10, pop: 2, resupply: 10, resupply_max: 10, company_max: 20, priority: 1)
  halftrack_allied = LightVehicle.find_by_name("halftrack_allied")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: halftrack_allied, ruleset: war_ruleset,
                              man: 210, mun: 0, fuel: 10, pop: 3, resupply: 10, resupply_max: 12, company_max: 12, priority: 1)
  quad_halftrack = LightVehicle.find_by_name("quad_halftrack")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: quad_halftrack, ruleset: war_ruleset,
                              man: 250, mun: 0, fuel: 80, pop: 6, resupply: 3, resupply_max: 6, company_max: 9, priority: 1)
  greyhound = LightVehicle.find_by_name("greyhound")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: greyhound, ruleset: war_ruleset,
                              man: 180, mun: 0, fuel: 60, pop: 7, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)
  t17 = LightVehicle.find_by_name("t17")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: t17, ruleset: war_ruleset,
                              man: 220, mun: 0, fuel: 70, pop: 7, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)

  sherman = Tank.find_by_name("sherman")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: sherman, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 300, pop: 12, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)
  sherman_croc = Tank.find_by_name("sherman_croc")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: sherman_croc, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 230, pop: 10, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  m10 = Tank.find_by_name("m10")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: m10, ruleset: war_ruleset,
                              man: 300, mun: 0, fuel: 240, pop: 9, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  m18 = Tank.find_by_name("m18")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: m18, ruleset: war_ruleset,
                              man: 300, mun: 0, fuel: 240, pop: 9, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)

  ## Infantry
  infantry = Doctrine.find_by_name("infantry")
  infantry_restriction = Restriction.find_by_doctrine_id(infantry.id)

  rangers = Infantry.find_by_name("rangers")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: rangers, ruleset: war_ruleset,
                              man: 300, mun: 90, fuel: 0, pop: 6, resupply: 2, resupply_max: 6, company_max: 10, priority: 1)
  ambush_riflemen = Infantry.find_by_name("ambush_riflemen")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: ambush_riflemen, ruleset: war_ruleset,
                              man: 150, mun: 0, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)

  spotter = SupportTeam.find_by_name("spotter")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: spotter, ruleset: war_ruleset,
                              man: 150, mun: 20, fuel: 0, pop: 3, resupply: 1, resupply_max: 2, company_max: 3, priority: 1)
  officer_infantry = SupportTeam.find_by_name("officer_infantry")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: officer_infantry, ruleset: war_ruleset,
                              man: 280, mun: 70, fuel: 0, pop: 4, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  jumbo = Tank.find_by_name("jumbo")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: jumbo, ruleset: war_ruleset,
                              man: 500, mun: 0, fuel: 450, pop: 14, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)

  howitzer = Emplacement.find_by_name("howitzer")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: howitzer, ruleset: war_ruleset,
                              man: 350, mun: 0, fuel: 180, pop: 8, resupply: 2, resupply_max: 4, company_max: 4, priority: 1)


  ## Airborne
  airborne_doc = Doctrine.find_by_name("airborne")
  airborne_restriction = Restriction.find_by_doctrine_id(airborne_doc.id)

  airborne = Infantry.find_by_name("airborne")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: airborne, ruleset: war_ruleset,
                              man: 300, mun: 0, fuel: 0, pop: 6, resupply: 4, resupply_max: 10, company_max: 20, priority: 1)
  assault_airborne = Infantry.find_by_name("assault_airborne")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: assault_airborne, ruleset: war_ruleset,
                              man: 300, mun: 0, fuel: 0, pop: 6, resupply: 2, resupply_max: 4, company_max: 6, priority: 1)

  airborne_hmg = SupportTeam.find_by_name("airborne_hmg")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: airborne_hmg, ruleset: war_ruleset,
                              man: 300, mun: 40, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  airborne_mortar = SupportTeam.find_by_name("airborne_mortar")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: airborne_mortar, ruleset: war_ruleset,
                              man: 430, mun: 50, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  airborne_atg = SupportTeam.find_by_name("airborne_atg")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: airborne_atg, ruleset: war_ruleset,
                              man: 480, mun: 130, fuel: 0, pop: 5, resupply: 4, resupply_max: 6, company_max: 6, priority: 1)
  airborne_sniper = SupportTeam.find_by_name("airborne_sniper")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: airborne_sniper, ruleset: war_ruleset,
                              man: 600, mun: 150, fuel: 0, pop: 8, resupply: 1, resupply_max: 1, company_max: 3, priority: 1)

  chaffee = Tank.find_by_name("chaffee")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: chaffee, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 180, pop: 10, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  ## Armor
  armor = Doctrine.find_by_name("armor")
  armor_restriction = Restriction.find_by_doctrine_id(armor.id)

  mech_inf = Infantry.find_by_name("mech_inf")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: mech_inf, ruleset: war_ruleset,
                              man: 240, mun: 0, fuel: 0, pop: 4, resupply: 4, resupply_max: 8, company_max: 10, priority: 1)

  sherman_105 = Tank.find_by_name("sherman_105")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: sherman_105, ruleset: war_ruleset,
                              man: 340, mun: 0, fuel: 280, pop: 9, resupply: 1, resupply_max: 2, company_max: 3, priority: 1)
  calliope = Tank.find_by_name("calliope")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: calliope, ruleset: war_ruleset,
                              man: 400, mun: 0, fuel: 450, pop: 13, resupply: 1, resupply_max: 2, company_max: 3, priority: 1)
  easy_eight = Tank.find_by_name("easy_eight")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: easy_eight, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 340, pop: 11, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)
  jackson = Tank.find_by_name("jackson")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: jackson, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 420, pop: 13, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  pershing = Tank.find_by_name("pershing")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: pershing, ruleset: war_ruleset,
                              man: 650, mun: 0, fuel: 650, pop: 16, resupply: 1, resupply_max: 2, company_max: 3, priority: 1)

  #################################################################################
  #################################### British ####################################
  british = Faction.find_by_name("british")
  british_restriction = Restriction.find_by_faction_id(british.id)

  ## Common
  infantry_section = Infantry.find_by_name("infantry_section")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: infantry_section, ruleset: war_ruleset,
                              man: 220, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1)
  recon_section = Infantry.find_by_name("recon_section")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: recon_section, ruleset: war_ruleset,
                              man: 200, mun: 0, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 10, priority: 1)
  sappers = Infantry.find_by_name("sappers")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: sappers, ruleset: war_ruleset,
                              man: 220, mun: 0, fuel: 0, pop: 4, resupply: 10, resupply_max: 15, company_max: 15, priority: 1)
  expert_sappers = Infantry.find_by_name("expert_sappers")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: expert_sappers, ruleset: war_ruleset,
                              man: 150, mun: 120, fuel: 0, pop: 3, resupply: 2, resupply_max: 4, company_max: 4, priority: 1)

  lt = SupportTeam.find_by_name("lt")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: lt, ruleset: war_ruleset,
                              man: 260, mun: 45, fuel: 0, pop: 2, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  captain = SupportTeam.find_by_name("captain")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: captain, ruleset: war_ruleset,
                              man: 300, mun: 70, fuel: 0, pop: 3, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  mortar_british = SupportTeam.find_by_name("mortar_british")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: mortar_british, ruleset: war_ruleset,
                              man: 400, mun: 50, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  vickers_hmg = SupportTeam.find_by_name("vickers_hmg")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: vickers_hmg, ruleset: war_ruleset,
                              man: 270, mun: 30, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  _17pdr = SupportTeam.find_by_name("17pdr")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: _17pdr, ruleset: war_ruleset,
                              man: 450, mun: 160, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)

  universal_carrier = LightVehicle.find_by_name("universal_carrier")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: universal_carrier, ruleset: war_ruleset,
                              man: 150, mun: 0, fuel: 10, pop: 2, resupply: 10, resupply_max: 15, company_max: 15, priority: 1)
  bren_carrier = LightVehicle.find_by_name("bren_carrier")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: bren_carrier, ruleset: war_ruleset,
                              man: 220, mun: 0, fuel: 30, pop: 3, resupply: 4, resupply_max: 12, company_max: 12, priority: 1)
  staghound = LightVehicle.find_by_name("staghound")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: staghound, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 120, pop: 9, resupply: 1, resupply_max: 3, company_max: 6, priority: 1)

  stuart = Tank.find_by_name("stuart")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: stuart, ruleset: war_ruleset,
                              man: 280, mun: 0, fuel: 80, pop: 7, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  cromwell = Tank.find_by_name("cromwell")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: cromwell, ruleset: war_ruleset,
                              man: 300, mun: 0, fuel: 250, pop: 10, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)
  cct = Tank.find_by_name("cct")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: cct, ruleset: war_ruleset,
                              man: 250, mun: 0, fuel: 120, pop: 3, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  kangaroo = Tank.find_by_name("kangaroo")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: kangaroo, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 110, pop: 4, resupply: 2, resupply_max: 4, company_max: 8, priority: 1)
  firefly = Tank.find_by_name("firefly")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: firefly, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 380, pop: 11, resupply: 1, resupply_max: 3, company_max: 4, priority: 1)

  _25pdr = Emplacement.find_by_name("25pdr")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: _25pdr, ruleset: war_ruleset,
                              man: 250, mun: 0, fuel: 110, pop: 7, resupply: 2, resupply_max: 4, company_max: 4, priority: 1)
  bofors = Emplacement.find_by_name("bofors")
  BaseRestrictionUnit.create!(restriction: british_restriction, unit: bofors, ruleset: war_ruleset,
                              man: 350, mun: 0, fuel: 60, pop: 3, resupply: 3, resupply_max: 4, company_max: 6, priority: 1)

  ## RCA
  rca = Doctrine.find_by_name("royal_artillery")
  rca_restriction = Restriction.find_by_doctrine_id(rca.id)

  # TODO Need to block infantry_section as they are replaced by canadian_section
  canadian_section = Infantry.find_by_name("canadian_section")
  BaseRestrictionUnit.create!(restriction: rca_restriction, unit: canadian_section, ruleset: war_ruleset,
                              man: 220, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1)
  ssf = Infantry.find_by_name("ssf")
  BaseRestrictionUnit.create!(restriction: rca_restriction, unit: ssf, ruleset: war_ruleset,
                              man: 260, mun: 30, fuel: 0, pop: 5, resupply: 1, resupply_max: 3, company_max: 4, priority: 1)


  stuart_recce = Tank.find_by_name("stuart_recce")
  BaseRestrictionUnit.create!(restriction: rca_restriction, unit: stuart_recce, ruleset: war_ruleset,
                              man: 280, mun: 0, fuel: 50, pop: 4, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  comet = Tank.find_by_name("comet")
  BaseRestrictionUnit.create!(restriction: rca_restriction, unit: comet, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 320, pop: 12, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)
  priest = Tank.find_by_name("priest")
  BaseRestrictionUnit.create!(restriction: rca_restriction, unit: priest, ruleset: war_ruleset,
                              man: 450, mun: 0, fuel: 260, pop: 9, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)

  ## Engineers
  engineers = Doctrine.find_by_name("engineers")
  engineers_restriction = Restriction.find_by_doctrine_id(engineers.id)

  churchill = Tank.find_by_name("churchill")
  BaseRestrictionUnit.create!(restriction: engineers_restriction, unit: churchill, ruleset: war_ruleset,
                              man: 300, mun: 0, fuel: 250, pop: 10, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  churchill_avre = Tank.find_by_name("churchill_avre")
  BaseRestrictionUnit.create!(restriction: engineers_restriction, unit: churchill_avre, ruleset: war_ruleset,
                              man: 400, mun: 0, fuel: 300, pop: 10, resupply: 1, resupply_max: 3, company_max: 4, priority: 1)
  churchill_croc = Tank.find_by_name("churchill_croc")
  BaseRestrictionUnit.create!(restriction: engineers_restriction, unit: churchill_croc, ruleset: war_ruleset,
                              man: 600, mun: 0, fuel: 500, pop: 15, resupply: 1, resupply_max: 3, company_max: 4, priority: 1)
  churchill_cct = Tank.find_by_name("churchill_cct")
  BaseRestrictionUnit.create!(restriction: engineers_restriction, unit: churchill_cct, ruleset: war_ruleset,
                              man: 300, mun: 0, fuel: 140, pop: 4, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  stuart_flame = Tank.find_by_name("stuart_flame")
  BaseRestrictionUnit.create!(restriction: engineers_restriction, unit: stuart_flame, ruleset: war_ruleset,
                              man: 260, mun: 0, fuel: 60, pop: 7, resupply: 2, resupply_max: 4, company_max: 4, priority: 1)

  ## Commandos
  commandos = Doctrine.find_by_name("commandos")
  commandos_restriction = Restriction.find_by_doctrine_id(commandos.id)

  commandos = Infantry.find_by_name("commandos")
  BaseRestrictionUnit.create!(restriction: commandos_restriction, unit: commandos, ruleset: war_ruleset,
                              man: 250, mun: 130, fuel: 0, pop: 6, resupply: 2, resupply_max: 6, company_max: 8, priority: 1)
  piat_commandos = Infantry.find_by_name("piat_commandos")
  BaseRestrictionUnit.create!(restriction: commandos_restriction, unit: piat_commandos, ruleset: war_ruleset,
                              man: 200, mun: 120, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  polish_commandos = Infantry.find_by_name("polish_commandos")
  BaseRestrictionUnit.create!(restriction: commandos_restriction, unit: polish_commandos, ruleset: war_ruleset,
                              man: 250, mun: 0, fuel: 0, pop: 7, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  commando_2pdr = SupportTeam.find_by_name("commando_2pdr")
  BaseRestrictionUnit.create!(restriction: commandos_restriction, unit: commando_2pdr, ruleset: war_ruleset,
                              man: 350, mun: 120, fuel: 0, pop: 4, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)
  commando_hmg = SupportTeam.find_by_name("commando_hmg")
  BaseRestrictionUnit.create!(restriction: commandos_restriction, unit: commando_hmg, ruleset: war_ruleset,
                              man: 300, mun: 40, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  commando_mortar = SupportTeam.find_by_name("commando_mortar")
  BaseRestrictionUnit.create!(restriction: commandos_restriction, unit: commando_mortar, ruleset: war_ruleset,
                              man: 430, mun: 40, fuel: 0, pop: 4, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)

  tetrarch = LightVehicle.find_by_name("tetrarch")
  BaseRestrictionUnit.create!(restriction: commandos_restriction, unit: tetrarch, ruleset: war_ruleset,
                              man: 280, mun: 0, fuel: 80, pop: 8, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  sas_jeep = LightVehicle.find_by_name("sas_jeep")
  BaseRestrictionUnit.create!(restriction: commandos_restriction, unit: sas_jeep, ruleset: war_ruleset,
                              man: 240, mun: 0, fuel: 20, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)

  infantry_glider = Glider.find_by_name("infantry_glider")
  BaseRestrictionUnit.create!(restriction: commandos_restriction, unit: infantry_glider, ruleset: war_ruleset,
                              man: 50, mun: 0, fuel: 0, pop: 0, resupply: 10, resupply_max: 10, company_max: 10, priority: 1)
  armor_glider = Glider.find_by_name("armor_glider")
  BaseRestrictionUnit.create!(restriction: commandos_restriction, unit: armor_glider, ruleset: war_ruleset,
                              man: 100, mun: 0, fuel: 10, pop: 0, resupply: 10, resupply_max: 10, company_max: 10, priority: 1)

  #################################################################################
  ################################### Wehrmacht ###################################
  wehrmacht = Faction.find_by_name("wehrmacht")
  wehrmacht_restriction = Restriction.find_by_faction_id(wehrmacht.id)

  ## Common
  volksgrenadiers = Infantry.find_by_name("volksgrenadiers")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: volksgrenadiers, ruleset: war_ruleset,
                              man: 190, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1)
  grenadiers = Infantry.find_by_name("grenadiers")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: grenadiers, ruleset: war_ruleset,
                              man: 240, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1)
  pioneers = Infantry.find_by_name("pioneers")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: pioneers, ruleset: war_ruleset,
                              man: 110, mun: 0, fuel: 0, pop: 2, resupply: 10, resupply_max: 15, company_max: 15, priority: 1)
  kch = Infantry.find_by_name("kch")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: kch, ruleset: war_ruleset,
                              man: 300, mun: 120, fuel: 0, pop: 6, resupply: 2, resupply_max: 4, company_max: 6, priority: 1)

  medic = SupportTeam.find_by_name("medic")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: medic, ruleset: war_ruleset,
                              man: 180, mun: 100, fuel: 0, pop: 2, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)
  mg42 = SupportTeam.find_by_name("mg42")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: mg42, ruleset: war_ruleset,
                              man: 270, mun: 50, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  mortar_axis = SupportTeam.find_by_name("mortar_axis")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: mortar_axis, ruleset: war_ruleset,
                              man: 500, mun: 70, fuel: 0, pop: 4, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  pak38 = SupportTeam.find_by_name("pak38")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: pak38, ruleset: war_ruleset,
                              man: 500, mun: 160, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)
  sniper_axis = SupportTeam.find_by_name("sniper_axis")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: sniper_axis, ruleset: war_ruleset,
                              man: 520, mun: 135, fuel: 0, pop: 8, resupply: 1, resupply_max: 1, company_max: 3, priority: 1)
  nebelwerfer = SupportTeam.find_by_name("nebelwerfer")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: nebelwerfer, ruleset: war_ruleset,
                              man: 350, mun: 0, fuel: 150, pop: 7, resupply: 2, resupply_max: 4, company_max: 5, priority: 1)

  motorcycle = LightVehicle.find_by_name("motorcycle")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: motorcycle, ruleset: war_ruleset,
                              man: 110, mun: 0, fuel: 10, pop: 2, resupply: 10, resupply_max: 10, company_max: 20, priority: 1)
  schwimmwagen_axis = LightVehicle.find_by_name("schwimmwagen_axis")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: schwimmwagen_axis, ruleset: war_ruleset,
                              man: 140, mun: 0, fuel: 10, pop: 2, resupply: 4, resupply_max: 8, company_max: 10, priority: 1)
  halftrack_axis = LightVehicle.find_by_name("halftrack_axis")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: halftrack_axis, ruleset: war_ruleset,
                              man: 200, mun: 0, fuel: 10, pop: 2, resupply: 10, resupply_max: 12, company_max: 12, priority: 1)
  flammenwerfer = LightVehicle.find_by_name("flammenwerfer")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: flammenwerfer, ruleset: war_ruleset,
                              man: 210, mun: 0, fuel: 50, pop: 5, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  walking_stuka = LightVehicle.find_by_name("walking_stuka")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: walking_stuka, ruleset: war_ruleset,
                              man: 250, mun: 0, fuel: 225, pop: 7, resupply: 2, resupply_max: 4, company_max: 4, priority: 1)
  puma = LightVehicle.find_by_name("puma")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: puma, ruleset: war_ruleset,
                              man: 280, mun: 0, fuel: 70, pop: 7, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)

  ostwind = Tank.find_by_name("ostwind")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: ostwind, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 230, pop: 10, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  geschutzwagen = Tank.find_by_name("geschutzwagen")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: geschutzwagen, ruleset: war_ruleset,
                              man: 270, mun: 0, fuel: 180, pop: 7, resupply: 3, resupply_max: 6, company_max: 10, priority: 1)
  stug = Tank.find_by_name("stug")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: stug, ruleset: war_ruleset,
                              man: 280, mun: 0, fuel: 170, pop: 8, resupply: 3, resupply_max: 6, company_max: 10, priority: 1)
  p4 = Tank.find_by_name("p4")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: p4, ruleset: war_ruleset,
                              man: 350, mun: 0, fuel: 300, pop: 12, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)
  panther_axis = Tank.find_by_name("panther_axis")
  BaseRestrictionUnit.create!(restriction: wehrmacht_restriction, unit: panther_axis, ruleset: war_ruleset,
                              man: 600, mun: 0, fuel: 520, pop: 15, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)

  ## DEFENSIVE
  defensive = Doctrine.find_by_name("defensive")
  defensive_restriction = Restriction.find_by_doctrine_id(defensive.id)


  fortress_pioneers = Infantry.find_by_name("fortress_pioneers")
  BaseRestrictionUnit.create!(restriction: defensive_restriction, unit: fortress_pioneers, ruleset: war_ruleset,
                              man: 230, mun: 0, fuel: 0, pop: 5, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  officer_def = SupportTeam.find_by_name("officer_def")
  BaseRestrictionUnit.create!(restriction: defensive_restriction, unit: officer_def, ruleset: war_ruleset,
                              man: 280, mun: 100, fuel: 0, pop: 3, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)

  flak88_def = Emplacement.find_by_name("flak88_def")
  BaseRestrictionUnit.create!(restriction: defensive_restriction, unit: flak88_def, ruleset: war_ruleset,
                              man: 550, mun: 0, fuel: 250, pop: 8, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)


  ## BLITZ
  blitz = Doctrine.find_by_name("blitz")
  blitz_restriction = Restriction.find_by_doctrine_id(blitz.id)

  stormtroopers = Infantry.find_by_name("stormtroopers")
  BaseRestrictionUnit.create!(restriction: blitz_restriction, unit: stormtroopers, ruleset: war_ruleset,
                              man: 300, mun: 0, fuel: 0, pop: 6, resupply: 2, resupply_max: 6, company_max: 10, priority: 1)
  flammentrupp = Infantry.find_by_name("flammentrupp")
  BaseRestrictionUnit.create!(restriction: blitz_restriction, unit: flammentrupp, ruleset: war_ruleset,
                              man: 150, mun: 100, fuel: 0, pop: 3, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  panzer_ace = SupportTeam.find_by_name("panzer_ace")
  BaseRestrictionUnit.create!(restriction: blitz_restriction, unit: panzer_ace, ruleset: war_ruleset,
                              man: 280, mun: 80, fuel: 0, pop: 2, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  stuh = Tank.find_by_name("stuh")
  BaseRestrictionUnit.create!(restriction: blitz_restriction, unit: stuh, ruleset: war_ruleset,
                              man: 320, mun: 0, fuel: 180, pop: 9, resupply: 2, resupply_max: 4, company_max: 6, priority: 1)
  tiger = Tank.find_by_name("tiger")
  BaseRestrictionUnit.create!(restriction: blitz_restriction, unit: tiger, ruleset: war_ruleset,
                              man: 725, mun: 0, fuel: 725, pop: 16, resupply: 1, resupply_max: 2, company_max: 3, priority: 1)

  ## TERROR
  terror = Doctrine.find_by_name("terror")
  terror_restriction = Restriction.find_by_doctrine_id(terror.id)

  sturmpioneers = Infantry.find_by_name("sturmpioneers")
  BaseRestrictionUnit.create!(restriction: terror_restriction, unit: sturmpioneers, ruleset: war_ruleset,
                              man: 250, mun: 0, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 10, priority: 1)

  saboteurs = SupportTeam.find_by_name("saboteurs")
  BaseRestrictionUnit.create!(restriction: terror_restriction, unit: saboteurs, ruleset: war_ruleset,
                              man: 100, mun: 0, fuel: 0, pop: 4, resupply: 2, resupply_max: 6, company_max: 6, priority: 1)
  officer_terror = SupportTeam.find_by_name("officer_terror")
  BaseRestrictionUnit.create!(restriction: terror_restriction, unit: officer_terror, ruleset: war_ruleset,
                              man: 280, mun: 100, fuel: 0, pop: 3, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)
  mortar_terror = SupportTeam.find_by_name("mortar_terror")
  BaseRestrictionUnit.create!(restriction: terror_restriction, unit: mortar_terror, ruleset: war_ruleset,
                              man: 400, mun: 70, fuel: 0, pop: 3, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  king_tiger = Tank.find_by_name("king_tiger")
  BaseRestrictionUnit.create!(restriction: terror_restriction, unit: king_tiger, ruleset: war_ruleset,
                              man: 800, mun: 0, fuel: 800, pop: 17, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  lefh = Emplacement.find_by_name("lefh")
  BaseRestrictionUnit.create!(restriction: terror_restriction, unit: lefh, ruleset: war_ruleset,
                              man: 350, mun: 0, fuel: 160, pop: 8, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)

  #################################################################################
  ################################## Panzer Elite #################################
  panzer_elite = Faction.find_by_name("panzer_elite")
  panzer_elite_restriction = Restriction.find_by_faction_id(panzer_elite.id)

  ## Common
  panzer_grenadiers = Infantry.find_by_name("panzer_grenadiers")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: panzer_grenadiers, ruleset: war_ruleset,
                              man: 170, mun: 0, fuel: 0, pop: 3, resupply: 99, resupply_max: 100, company_max: 100, priority: 1)
  assault_grenadiers = Infantry.find_by_name("assault_grenadiers")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: assault_grenadiers, ruleset: war_ruleset,
                              man: 170, mun: 85, fuel: 0, pop: 3, resupply: 10, resupply_max: 15, company_max: 15, priority: 1)
  tank_busters = Infantry.find_by_name("tank_busters")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: tank_busters, ruleset: war_ruleset,
                              man: 170, mun: 110, fuel: 0, pop: 3, resupply: 10, resupply_max: 20, company_max: 20, priority: 1)

  infantry_halftrack = LightVehicle.find_by_name("infantry_halftrack")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: infantry_halftrack, ruleset: war_ruleset,
                              man: 180, mun: 0, fuel: 20, pop: 2, resupply: 10, resupply_max: 15, company_max: 15, priority: 1)
  mortar_halftrack = LightVehicle.find_by_name("mortar_halftrack")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: mortar_halftrack, ruleset: war_ruleset,
                              man: 500, mun: 70, fuel: 50, pop: 6, resupply: 2, resupply_max: 4, company_max: 6, priority: 1)
  vampire_halftrack = LightVehicle.find_by_name("vampire_halftrack")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: vampire_halftrack, ruleset: war_ruleset,
                              man: 240, mun: 0, fuel: 40, pop: 3, resupply: 2, resupply_max: 4, company_max: 5, priority: 1)
  medic_halftrack = LightVehicle.find_by_name("medic_halftrack")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: medic_halftrack, ruleset: war_ruleset,
                              man: 300, mun: 100, fuel: 50, pop: 4, resupply: 2, resupply_max: 3, company_max: 3, priority: 1)
  light_at_halftrack = LightVehicle.find_by_name("light_at_halftrack")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: light_at_halftrack, ruleset: war_ruleset,
                              man: 230, mun: 75, fuel: 70, pop: 4, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  scout_car = LightVehicle.find_by_name("scout_car")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: scout_car, ruleset: war_ruleset,
                              man: 150, mun: 0, fuel: 20, pop: 2, resupply: 10, resupply_max: 10, company_max: 10, priority: 1)
  armored_car = LightVehicle.find_by_name("armored_car")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: armored_car, ruleset: war_ruleset,
                              man: 240, mun: 0, fuel: 50, pop: 5, resupply: 4, resupply_max: 8, company_max: 12, priority: 1)

  marder = Tank.find_by_name("marder")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: marder, ruleset: war_ruleset,
                              man: 270, mun: 0, fuel: 180, pop: 6, resupply: 4, resupply_max: 8, company_max: 10, priority: 1)
  hotchkiss = Tank.find_by_name("hotchkiss")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: hotchkiss, ruleset: war_ruleset,
                              man: 260, mun: 0, fuel: 70, pop: 8, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  p4_ist = Tank.find_by_name("p4_ist")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: p4_ist, ruleset: war_ruleset,
                              man: 350, mun: 0, fuel: 180, pop: 9, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)
  panther_pe = Tank.find_by_name("panther_pe")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: panther_pe, ruleset: war_ruleset,
                              man: 600, mun: 0, fuel: 520, pop: 15, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)
  bergetiger = Tank.find_by_name("bergetiger")
  BaseRestrictionUnit.create!(restriction: panzer_elite_restriction, unit: bergetiger, ruleset: war_ruleset,
                              man: 240, mun: 0, fuel: 180, pop: 4, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)

  ## SE
  scorched_earth = Doctrine.find_by_name("scorched_earth")
  scorched_earth_restriction = Restriction.find_by_doctrine_id(scorched_earth.id)

  ostfront_veterans = Infantry.find_by_name("ostfront_veterans")
  BaseRestrictionUnit.create!(restriction: scorched_earth_restriction, unit: ostfront_veterans, ruleset: war_ruleset,
                              man: 300, mun: 0, fuel: 0, pop: 5, resupply: 2, resupply_max: 4, company_max: 6, priority: 1)

  kettenkrad_se = LightVehicle.find_by_name("kettenkrad_se")
  BaseRestrictionUnit.create!(restriction: scorched_earth_restriction, unit: kettenkrad_se, ruleset: war_ruleset,
                              man: 100, mun: 20, fuel: 5, pop: 2, resupply: 4, resupply_max: 10, company_max: 15, priority: 1)
  schwimmwagen_se = LightVehicle.find_by_name("schwimmwagen_se")
  BaseRestrictionUnit.create!(restriction: scorched_earth_restriction, unit: schwimmwagen_se, ruleset: war_ruleset,
                              man: 100, mun: 20, fuel: 5, pop: 2, resupply: 3, resupply_max: 6, company_max: 10, priority: 1)

  stup = Tank.find_by_name("stup")
  BaseRestrictionUnit.create!(restriction: scorched_earth_restriction, unit: stup, ruleset: war_ruleset,
                              man: 400, mun: 0, fuel: 300, pop: 11, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)
  hummel = Tank.find_by_name("hummel")
  BaseRestrictionUnit.create!(restriction: scorched_earth_restriction, unit: hummel, ruleset: war_ruleset,
                              man: 400, mun: 0, fuel: 240, pop: 10, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)
  flammen_hotchkiss = Tank.find_by_name("flammen_hotchkiss")
  BaseRestrictionUnit.create!(restriction: scorched_earth_restriction, unit: flammen_hotchkiss, ruleset: war_ruleset,
                              man: 260, mun: 0, fuel: 90, pop: 7, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  ## Luft
  luftwaffe = Doctrine.find_by_name("luftwaffe")
  luftwaffe_restriction = Restriction.find_by_doctrine_id(luftwaffe.id)

  falls = Infantry.find_by_name("falls")
  BaseRestrictionUnit.create!(restriction: luftwaffe_restriction, unit: falls, ruleset: war_ruleset,
                              man: 240, mun: 0, fuel: 0, pop: 4, resupply: 5, resupply_max: 10, company_max: 20, priority: 1)
  gebirgs = Infantry.find_by_name("gebirgs")
  BaseRestrictionUnit.create!(restriction: luftwaffe_restriction, unit: gebirgs, ruleset: war_ruleset,
                              man: 200, mun: 100, fuel: 0, pop: 4, resupply: 2, resupply_max: 4, company_max: 6, priority: 1)
  luft_infantry = Infantry.find_by_name("luft_infantry")
  BaseRestrictionUnit.create!(restriction: luftwaffe_restriction, unit: luft_infantry, ruleset: war_ruleset,
                              man: 180, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1)
  crete_vets = Infantry.find_by_name("crete_vets")
  BaseRestrictionUnit.create!(restriction: luftwaffe_restriction, unit: crete_vets, ruleset: war_ruleset,
                              man: 320, mun: 20, fuel: 0, pop: 6, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  pak40 = SupportTeam.find_by_name("pak40")
  BaseRestrictionUnit.create!(restriction: luftwaffe_restriction, unit: pak40, ruleset: war_ruleset,
                              man: 450, mun: 160, fuel: 0, pop: 5, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)

  kettenkrad_luft = LightVehicle.find_by_name("kettenkrad_luft")
  BaseRestrictionUnit.create!(restriction: luftwaffe_restriction, unit: kettenkrad_luft, ruleset: war_ruleset,
                              man: 150, mun: 20, fuel: 10, pop: 3, resupply: 4, resupply_max: 10, company_max: 15, priority: 1)
  schwimmwagen_luft = LightVehicle.find_by_name("schwimmwagen_luft")
  BaseRestrictionUnit.create!(restriction: luftwaffe_restriction, unit: schwimmwagen_luft, ruleset: war_ruleset,
                              man: 100, mun: 0, fuel: 10, pop: 2, resupply: 3, resupply_max: 6, company_max: 10, priority: 1)

  wirbelwind = Tank.find_by_name("wirbelwind")
  BaseRestrictionUnit.create!(restriction: luftwaffe_restriction, unit: wirbelwind, ruleset: war_ruleset,
                              man: 280, mun: 0, fuel: 120, pop: 7, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)

  flakvierling_38 = Emplacement.find_by_name("flakvierling_38")
  BaseRestrictionUnit.create!(restriction: luftwaffe_restriction, unit: flakvierling_38, ruleset: war_ruleset,
                              man: 250, mun: 0, fuel: 60, pop: 3, resupply: 2, resupply_max: 4, company_max: 6, priority: 1)
  flak88_luft = Emplacement.find_by_name("flak88_luft")
  BaseRestrictionUnit.create!(restriction: luftwaffe_restriction, unit: flak88_luft, ruleset: war_ruleset,
                              man: 550, mun: 0, fuel: 250, pop: 8, resupply: 1, resupply_max: 3, company_max: 3, priority: 1)

  ## TH
  tank_hunters = Doctrine.find_by_name("tank_hunters")
  tank_hunters_restriction = Restriction.find_by_doctrine_id(tank_hunters.id)

  kettenkrad_th = LightVehicle.find_by_name("kettenkrad_th")
  BaseRestrictionUnit.create!(restriction: tank_hunters_restriction, unit: kettenkrad_th, ruleset: war_ruleset,
                              man: 100, mun: 35, fuel: 5, pop: 2, resupply: 4, resupply_max: 10, company_max: 10, priority: 1)
  schwimmwagen_th = LightVehicle.find_by_name("schwimmwagen_th")
  BaseRestrictionUnit.create!(restriction: tank_hunters_restriction, unit: schwimmwagen_th, ruleset: war_ruleset,
                              man: 100, mun: 35, fuel: 5, pop: 2, resupply: 3, resupply_max: 6, company_max: 10, priority: 1)

  hetzer = Tank.find_by_name("hetzer")
  BaseRestrictionUnit.create!(restriction: tank_hunters_restriction, unit: hetzer, ruleset: war_ruleset,
                              man: 350, mun: 0, fuel: 200, pop: 9, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  jagdpanther = Tank.find_by_name("jagdpanther")
  BaseRestrictionUnit.create!(restriction: tank_hunters_restriction, unit: jagdpanther, ruleset: war_ruleset,
                              man: 1050, mun: 0, fuel: 750, pop: 16, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  nashorn = Tank.find_by_name("nashorn")
  BaseRestrictionUnit.create!(restriction: tank_hunters_restriction, unit: nashorn, ruleset: war_ruleset,
                              man: 450, mun: 0, fuel: 400, pop: 13, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)
  stug_ace_pe = Tank.find_by_name("stug_ace_pe")
  BaseRestrictionUnit.create!(restriction: tank_hunters_restriction, unit: stug_ace_pe, ruleset: war_ruleset,
                              man: 280, mun: 45, fuel: 230, pop: 10, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

end
