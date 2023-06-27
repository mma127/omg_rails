FactoryBot.define do
  factory :unit_replacement, class: "Upgrades::UnitReplacement" do
    sequence(:name) { |n| "unit replace name #{n}" }
    sequence(:const_name) { |n| "unit replace const_name #{n}" }
    sequence(:display_name) { |n| "unit replace display_name #{n}" }

    model_count { 5 }
    additional_model_count { nil }
  end
end
