after :upgrades do
  war_ruleset = Ruleset.find_by_name("war")

  #################################################################################
  ################################### Americans ###################################
  americans = Faction.find_by_name("americans")
  american_restriction = Restriction.find_by_faction_id(americans.id)

  ## Common
  riflemen = Infantry.find_by(name: "riflemen")

  ally_grenade = Upgrade.find_by(name: "ally_grenade")
  ally_grenade_enabled = EnabledUpgrade.create!(restriction: american_restriction, upgrade: ally_grenade, ruleset: war_ruleset,
                                                mun: 35, uses: 2)
  RestrictionUpgradeUnit.create!(restriction_upgrade: ally_grenade_enabled, unit: riflemen)


end
