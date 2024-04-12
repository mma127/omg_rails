after :rulesets do
  def get_upgrade_class(type)
    case type
    when "single_weapon"
      Upgrades::SingleWeapon
    when "consumable"
      Upgrades::Consumable
    when "ability"
      Upgrades::Ability
    when "building"
      Upgrades::Building
    when "passive"
      Upgrades::Passive
    when "squad_weapon"
      Upgrades::SquadWeapon
    when "unit_replacement"
      Upgrades::UnitReplacement
    else
      raise StandardError.new "Unknown upgrade type #{type}"
    end
  end

  csv_paths = %w[db/seeds/ame_enabled_upgrades.csv db/seeds/cmw_enabled_upgrades.csv db/seeds/wehr_enabled_upgrades.csv db/seeds/pe_enabled_upgrades.csv].freeze

  upgrades = []

  csv_paths.each do |path|
    CSV.foreach(path, headers: true) do |row|
      name = row['upgrade']
      const = row['const']
      display_name = row['display_name']
      description = row['description']
      model_count = row['model_count']
      add_model_count = row['add_model_count']
      type = row['type']
      upgrade_class = get_upgrade_class(type)
      puts "#{name} | #{const} | #{display_name} | #{model_count} | #{add_model_count} | #{type}"

      upgrades << upgrade_class.new(name: name, const_name: const, display_name: display_name, description: description,
                                    model_count: model_count, additional_model_count: add_model_count)
    end
  end
  Upgrade.import! upgrades
end
