FactoryBot.define do
  factory :squad_weapon, class: "Upgrades::SquadWeapon" do
    sequence(:name) { |n| "squad weapon name #{n}" }
    sequence(:const_name) { |n| "squad weapon const_name #{n}" }
    sequence(:display_name) { |n| "squad weapon display_name #{n}" }

    unitwide_upgrade_slots { 1 }
    upgrade_slots { nil }
    model_count { nil }
    additional_model_count { nil }
  end
end
