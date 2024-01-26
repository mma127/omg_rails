Ruleset.create!(name: "War 1",
                ruleset_type: Ruleset.ruleset_types[:war],
                is_active: true,
                description: "OMG standard WAR format",
                starting_man: 9000,
                starting_mun: 1900,
                starting_fuel: 1400,
                starting_vps: 20, # FIXME: restore to 15
                max_vps: 25,
                max_resource_bonuses: 5)
