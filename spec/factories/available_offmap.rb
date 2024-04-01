FactoryBot.define do
  factory :available_offmap do
    transient do
      ruleset { create :ruleset }
    end

    company { association :company, ruleset: ruleset }
    offmap { association :offmap, ruleset: ruleset }

    available { 4 }
    max { 4 }
    mun { 100 }
  end
end
