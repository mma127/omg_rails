FactoryBot.define do
  factory :squad do
    transient do
      ruleset { create :ruleset }
    end

    vet { 0 }
    tab_category { "core" }
    category_position { 0 }
    sequence :uuid do |n| "uuid #{n}" end

    company { association :company, ruleset: ruleset }
    available_unit { association :available_unit, ruleset: ruleset }
  end
end

