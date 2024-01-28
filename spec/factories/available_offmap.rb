FactoryBot.define do
  factory :available_offmap do
    transient do
      ruleset { create :ruleset }
    end

    company { association :company, ruleset: ruleset }
    association :offmap

    available { 4 }
    max { 4 }
    mun { 100 }
  end
end
