FactoryBot.define do
  factory :consumable, class: "Upgrades::Consumable" do
    sequence(:name) { |n| "consumable name #{n}" }
    sequence(:const_name) { |n| "consumable const_name #{n}" }
    sequence(:display_name) { |n| "consumable display_name #{n}" }

    model_count { nil }
    additional_model_count { nil }
  end
end
