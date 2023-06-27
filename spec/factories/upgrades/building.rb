FactoryBot.define do
  factory :building, class: "Upgrades::Building" do
    sequence(:name) { |n| "building name #{n}" }
    sequence(:const_name) { |n| "building const_name #{n}" }
    sequence(:display_name) { |n| "building display_name #{n}" }

    model_count { nil }
    additional_model_count { nil }
  end
end
