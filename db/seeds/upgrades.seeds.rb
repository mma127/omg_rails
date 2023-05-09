after :restriction_units do
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

  upgrades = []
  CSV.foreach('db/seeds/enabled_upgrades.csv', headers: true) do |row|
    name = row['upgrade']
    const = row['const']
    display_name = row['display_name']
    description = row['description']
    slots = row['slots']
    unitwide_slots = row['unitwide_slots']
    model_count = row['model_count']
    add_model_count = row['add_model_count']
    type = row['type']
    upgrade_class = get_upgrade_class(type)

    upgrades << upgrade_class.new(name: name, const_name: const, display_name: display_name, description: description,
                                  upgrade_slots: slots, unitwide_upgrade_slots: unitwide_slots,
                                  model_count: model_count, additional_model_count: add_model_count)
  end
  Upgrade.import! upgrades
end
