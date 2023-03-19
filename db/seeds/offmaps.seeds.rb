require 'csv'

after :restrictions do
  def snake_case(str)
    str.parameterize.underscore
  end

  def title_case(str)
    str.humanize.titleize
  end

  ruleset = Ruleset.find_by(name: "war")
  CSV.foreach('db/seeds/offmaps.csv', headers: true) do |row|
    name = snake_case(row["internal_name"])
    display_name = title_case(name)
    offmap = Offmap.create!(name: name,
                            display_name: display_name,
                            const_name: row["const_name"],
                            description: row["description"],
                            upgrade_rgd: row["upgrade_path"],
                            ability_rgd: row["ability_path"],
                            cooldown: row["cooldown"],
                            duration: row["duration"],
                            unlimited_uses: ActiveModel::Type::Boolean.new.cast(row["unlimited_uses"]),
                            buffs: row["buffs"],
                            debuffs: row["debuffs"],
                            weapon_rgd: row["weapon"],
                            shells_fired: row["shells_fired"]
    )

    puts "name: #{name}, const_name: #{row["const_name"]}, doctrine: #{row["doctrine"]}, unlock: #{row["unlock"]}"
    doctrine = Doctrine.find_by(name: row["doctrine"])
    if doctrine.present?
      unlock = Unlock.find_by(name: row["unlock"])
      puts "-- Doctrine #{doctrine.name} and unlock #{unlock.name}"
      doctrine_unlock = DoctrineUnlock.find_by(unlock: unlock, doctrine: doctrine)
      restriction = Restriction.find_by(doctrine_unlock: doctrine_unlock)
      EnabledOffmap.create!(restriction: restriction, offmap: offmap, mun: row["mun"].to_i, max: row["max"].to_i, ruleset: ruleset)
    else
      faction = Faction.find_by(name: row["doctrine"])
      puts "-- Faction #{faction.name}"
      restriction = Restriction.find_by(faction: faction)
      EnabledOffmap.create!(restriction: restriction, offmap: offmap, mun: row["mun"].to_i, max: row["max"].to_i, ruleset: ruleset)
    end
  end
end
