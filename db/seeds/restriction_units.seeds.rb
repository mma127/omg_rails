after :restrictions do
  # Create RestrictionUnits to associate Units with Restrictions and their costs per restriction
  # This associates Units with a Faction, Doctrine, or Unlock, and allows them to be priced separately
  # For example, a Riflemen unit in the Infantry doctrine can have different pricing and resupply than the
  # generic American faction Riflemen unit

  #################################################################################
  ################################### Americans ###################################
  americans = Faction.find_by_name("americans")
  american_restriction = Restriction.find_by_faction_id(americans.id)

  riflemen = Infantry.find_by_name("riflemen")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: riflemen,
                              man: 210, mun: 0, fuel: 0, pop: 5, resupply: 99, resupply_max: 100, company_max: 100, priority: 1)
  engineers = Infantry.find_by_name("engineers")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: engineers,
                              man: 110, mun: 0, fuel: 0, pop: 3, resupply: 10, resupply_max: 15, company_max: 15, priority: 1)

  allied_sniper = SupportTeam.find_by_name("allied_sniper")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: allied_sniper,
                              man: 580, mun: 150, fuel: 0, pop: 8, resupply: 1, resupply_max: 1, company_max: 3, priority: 1)
  allied_hmg = SupportTeam.find_by_name("allied_hmg")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: allied_hmg,
                              man: 270, mun: 40, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  allied_mortar = SupportTeam.find_by_name("allied_mortar")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: allied_mortar,
                              man: 400, mun: 50, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  allied_57atg = SupportTeam.find_by_name("allied_57atg")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: allied_57atg,
                              man: 450, mun: 130, fuel: 0, pop: 5, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)

  jeep = LightVehicle.find_by_name("jeep")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: jeep,
                              man: 110, mun: 0, fuel: 10, pop: 2, resupply: 10, resupply_max: 10, company_max: 20, priority: 1)
  allied_halftrack = LightVehicle.find_by_name("allied_halftrack")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: allied_halftrack,
                              man: 210, mun: 0, fuel: 10, pop: 3, resupply: 10, resupply_max: 12, company_max: 12, priority: 1)
  quad_halftrack = LightVehicle.find_by_name("quad_halftrack")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: quad_halftrack,
                              man: 250, mun: 0, fuel: 80, pop: 6, resupply: 3, resupply_max: 6, company_max: 9, priority: 1)
  greyhound = LightVehicle.find_by_name("greyhound")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: greyhound,
                              man: 180, mun: 0, fuel: 60, pop: 7, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)
  t17 = LightVehicle.find_by_name("t17")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: t17,
                              man: 220, mun: 0, fuel: 70, pop: 7, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)

  sherman = Tank.find_by_name("sherman")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: sherman,
                              man: 320, mun: 0, fuel: 300, pop: 12, resupply: 4, resupply_max: 8, company_max: 8, priority: 1)
  sherman_croc = Tank.find_by_name("sherman_croc")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: sherman_croc,
                              man: 320, mun: 0, fuel: 230, pop: 10, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  m10 = Tank.find_by_name("m10")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: m10,
                              man: 300, mun: 0, fuel: 240, pop: 9, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)
  m18 = Tank.find_by_name("m18")
  BaseRestrictionUnit.create!(restriction: american_restriction, unit: m18,
                              man: 300, mun: 0, fuel: 240, pop: 9, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)

  ## Infantry
  infantry = Doctrine.find_by_name("infantry")
  infantry_restriction = Restriction.find_by_doctrine_id(infantry.id)

  rangers = Infantry.find_by_name("rangers")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: rangers,
                              man: 300, mun: 90, fuel: 0, pop: 6, resupply: 2, resupply_max: 6, company_max: 10, priority: 1)
  ambush_riflemen = Infantry.find_by_name("ambush_riflemen")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: ambush_riflemen,
                              man: 150, mun: 0, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 8, priority: 1)

  spotter = SupportTeam.find_by_name("spotter")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: spotter,
                              man: 150, mun: 20, fuel: 0, pop: 3, resupply: 1, resupply_max: 2, company_max: 3, priority: 1)
  allied_officer = SupportTeam.find_by_name("allied_officer")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: allied_officer,
                              man: 280, mun: 70, fuel: 0, pop: 4, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  jumbo = Tank.find_by_name("jumbo")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: jumbo,
                              man: 500, mun: 0, fuel: 450, pop: 14, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)

  howitzer = Emplacement.find_by_name("howitzer")
  BaseRestrictionUnit.create!(restriction: infantry_restriction, unit: howitzer,
                              man: 350, mun: 0, fuel: 180, pop: 8, resupply: 2, resupply_max: 4, company_max: 4, priority: 1)


  ## Airborne
  airborne_doc = Doctrine.find_by_name("airborne")
  airborne_restriction = Restriction.find_by_doctrine_id(airborne_doc.id)

  airborne = Infantry.find_by_name("airborne")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: airborne,
                              man: 300, mun: 0, fuel: 0, pop: 6, resupply: 4, resupply_max: 10, company_max: 20, priority: 1)
  assault_airborne = Infantry.find_by_name("assault_airborne")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: assault_airborne,
                              man: 300, mun: 0, fuel: 0, pop: 6, resupply: 2, resupply_max: 4, company_max: 6, priority: 1)

  airborne_hmg = SupportTeam.find_by_name("airborne_hmg")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: airborne_hmg,
                              man: 300, mun: 40, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  airborne_mortar = SupportTeam.find_by_name("airborne_mortar")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: airborne_mortar,
                              man: 430, mun: 50, fuel: 0, pop: 3, resupply: 3, resupply_max: 6, company_max: 6, priority: 1)
  airborne_atg = SupportTeam.find_by_name("airborne_atg")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: airborne_atg,
                              man: 480, mun: 130, fuel: 0, pop: 5, resupply: 4, resupply_max: 6, company_max: 6, priority: 1)
  airborne_sniper = SupportTeam.find_by_name("airborne_sniper")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: airborne_sniper,
                              man: 600, mun: 150, fuel: 0, pop: 8, resupply: 1, resupply_max: 1, company_max: 3, priority: 1)

  chaffee = Tank.find_by_name("chaffee")
  BaseRestrictionUnit.create!(restriction: airborne_restriction, unit: chaffee,
                              man: 320, mun: 0, fuel: 180, pop: 10, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)

  ## Armor
  armor = Doctrine.find_by_name("armor")
  armor_restriction = Restriction.find_by_doctrine_id(armor.id)

  mech_inf = Infantry.find_by_name("mech_inf")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: mech_inf,
                              man: 240, mun: 0, fuel: 0, pop: 4, resupply: 4, resupply_max: 8, company_max: 10, priority: 1)

  sherman_105 = Tank.find_by_name("sherman_105")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: sherman_105,
                              man: 340, mun: 0, fuel: 280, pop: 9, resupply: 1, resupply_max: 2, company_max: 3, priority: 1)
  calliope = Tank.find_by_name("calliope")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: calliope,
                              man: 400, mun: 0, fuel: 450, pop: 13, resupply: 1, resupply_max: 2, company_max: 3, priority: 1)
  easy_eight = Tank.find_by_name("easy_eight")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: easy_eight,
                              man: 320, mun: 0, fuel: 340, pop: 11, resupply: 1, resupply_max: 2, company_max: 2, priority: 1)
  jackson = Tank.find_by_name("jackson")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: jackson,
                              man: 320, mun: 0, fuel: 420, pop: 13, resupply: 1, resupply_max: 1, company_max: 1, priority: 1)
  pershing = Tank.find_by_name("pershing")
  BaseRestrictionUnit.create!(restriction: armor_restriction, unit: pershing,
                              man: 650, mun: 0, fuel: 650, pop: 16, resupply: 1, resupply_max: 2, company_max: 3, priority: 1)

  #################################################################################
  #################################### British ####################################

  #################################################################################
  ################################### Wehrmacht ###################################

  #################################################################################
  ################################## Panzer Elite #################################

end
