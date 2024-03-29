FactoryBot.define do
  factory :single_weapon, class: "Upgrades::SingleWeapon" do
    sequence(:name) { |n| "single weapon name #{n}" }
    sequence(:const_name) { |n| "single weapon const_name #{n}" }
    sequence(:display_name) { |n| "single weapon display_name #{n}" }

    model_count { nil }
    additional_model_count { nil }
  end
end
