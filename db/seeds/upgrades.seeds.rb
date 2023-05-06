after :restriction_units do
  # Create upgrades
  ally_grenade = Upgrades::Consumable.create!(name: "ally_grenade", const_name: "ALLY.GRENADE", display_name: "Grenade",
                                              description: "Line infantry grenade")
  ranger_grenade = Upgrades::Consumable.create!(name: "ranger_grenade", const_name: "ALLY.GRENADE", display_name: "Grenade",
                                                description: "Elite infantry grenade")

end
