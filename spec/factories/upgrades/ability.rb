FactoryBot.define do
  factory :ability, class: "Upgrades::Ability" do
    sequence(:name) { |n| "ability name #{n}" }
    sequence(:const_name) { |n| "ability const_name #{n}" }
    sequence(:display_name) { |n| "ability display_name #{n}" }

    unitwide_upgrade_slots { 0 }
    upgrade_slots { 0 }
    model_count { nil }
    additional_model_count { nil }
  end
end
