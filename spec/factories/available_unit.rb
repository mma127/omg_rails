FactoryBot.define do
  factory :available_unit do
    transient do
      ruleset { create :ruleset }
    end

    available { 4 }
    resupply { 2 }
    resupply_max { 3 }
    company_max { 5 }
    pop { 5 }
    man { 200 }
    mun { 50 }
    fuel { 40 }
    callin_modifier { 1 }
    type { "BaseAvailableUnit" }

    company { association :company, ruleset: ruleset }
    association :unit
  end
end
