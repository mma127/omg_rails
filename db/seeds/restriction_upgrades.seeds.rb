after :upgrades do
  war_ruleset = Ruleset.find_by_name("war")

  @faction_restrictions_by_name = {}
  @doctrine_restrictions_by_name = {}
  @unlock_restrictions_by_name = {}

  def get_restriction(faction_name, doctrine_name, unlock_name)
    if faction_name.present?
      if @faction_restrictions_by_name.include? faction_name
        @faction_restrictions_by_name[faction_name]
      else
        faction = Faction.find_by!(name: faction_name)
        faction_restriction = Restriction.find_by(faction: faction)
        @faction_restrictions_by_name[faction_name] = faction_restriction
        faction_restriction
      end
    elsif unlock_name.present? && doctrine_name.present?
      if @unlock_restrictions_by_name.include? unlock_name
        @unlock_restrictions_by_name[unlock_name]
      else
        doctrine = Doctrine.find_by!(name: doctrine_name)
        unlock = Unlock.find_by!(name: unlock_name)
        doctrine_unlock = DoctrineUnlock.find_by!(doctrine: doctrine, unlock: unlock)
        doctrine_unlock_restriction = Restriction.find_by!(doctrine_unlock: doctrine_unlock)
        @unlock_restrictions_by_name[unlock_name] = doctrine_unlock_restriction
        doctrine_unlock_restriction
      end
    elsif doctrine_name.present?
      if @doctrine_restrictions_by_name.include? doctrine_name
        @doctrine_restrictions_by_name[doctrine_name]
      else
        doctrine = Doctrine.find_by!(name: doctrine_name)
        doctrine_restriction = Restriction.find_by!(doctrine: doctrine)
        @doctrine_restrictions_by_name[doctrine_name] = doctrine_restriction
        doctrine_restriction
      end
    else
      raise StandardError.new "Invalid combination of faction name [#{faction_name}], doctrine name [#{doctrine_name}], and unlock name [#{unlock_name}]"
    end
  end

  csv_paths = %w[db/seeds/ame_enabled_upgrades.csv db/seeds/cmw_enabled_upgrades.csv db/seeds/wehr_enabled_upgrades.csv db/seeds/pe_enabled_upgrades.csv].freeze
  csv_paths.each do |path|
    CSV.foreach(path, headers: true) do |row|
      puts "#{row["upgrade"]} | #{row["const"]} | #{row['faction_restriction']}, #{row['doctrine_restriction']}, #{row['unlock_restriction']} | #{row["unit"]}"
      man = row['man']
      mun = row['mun']
      fuel = row['fuel']
      pop = row['pop']
      uses = row['uses']
      max = row['max']
      slots = row['slots']
      unitwide_slots = row['unitwide_slots']

      unit = Unit.find_by!(name: row['unit'])
      upgrade = Upgrade.find_by!(name: row['upgrade'])
      restriction = get_restriction(row['faction_restriction'], row['doctrine_restriction'], row['unlock_restriction'])
      enabled_upgrade = EnabledUpgrade.find_or_create_by!(restriction: restriction, upgrade: upgrade, ruleset: war_ruleset,
                                                          man: man, mun: mun, fuel: fuel, pop: pop, uses: uses, max: max,
                                                          upgrade_slots: slots, unitwide_upgrade_slots: unitwide_slots,
                                                          priority: 1)
      RestrictionUpgradeUnit.create!(restriction_upgrade: enabled_upgrade, unit: unit)
    end
  end

  CSV.foreach('db/seeds/disabled_upgrades.csv', headers: true) do |row|
    unit = Unit.find_by!(name: row['unit'])
    upgrade = Upgrade.find_by!(name: row['upgrade'])
    restriction = get_restriction(row['faction_restriction'], row['doctrine_restriction'], row['unlock_restriction'])
    disabled_upgrade = DisabledUpgrade.find_or_create_by!(restriction: restriction, upgrade: upgrade, ruleset: war_ruleset, priority: 1)
    RestrictionUpgradeUnit.create!(restriction_upgrade: disabled_upgrade, unit: unit)
  end

  CSV.foreach('db/seeds/upgrade_swaps.csv', headers: true) do |row|
    old_upgrade = Upgrade.find_by!(name: row['old_upgrade'])
    new_upgrade = Upgrade.find_by!(name: row['new_upgrade'])
    unlock = Unlock.find_by!(name: row['unlock_restriction'])
    unit = Unit.find_by!(name: row['unit'])

    upgrade_swap = UpgradeSwap.find_or_create_by!(unlock: unlock, old_upgrade: old_upgrade, new_upgrade: new_upgrade)
    UpgradeSwapUnit.create!(upgrade_swap: upgrade_swap, unit: unit)
  end
end
