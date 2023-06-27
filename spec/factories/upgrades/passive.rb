FactoryBot.define do
  factory :passive, class: "Upgrades::Passive" do
    sequence(:name) { |n| "passive name #{n}" }
    sequence(:const_name) { |n| "passive const_name #{n}" }
    sequence(:display_name) { |n| "passive display_name #{n}" }

    model_count { nil }
    additional_model_count { nil }
  end
end
