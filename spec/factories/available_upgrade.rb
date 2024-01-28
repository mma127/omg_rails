FactoryBot.define do
  factory :available_upgrade do
    transient do
      ruleset { create :ruleset }
    end

    pop { 5 }
    man { 200 }
    mun { 50 }
    fuel { 40 }
    type { "BaseAvailableUpgrade" }

    company { association :company, ruleset: ruleset }
    association :upgrade
    association :unit
  end
end
