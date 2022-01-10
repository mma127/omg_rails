FactoryBot.define do
  factory :base_restriction_unit do
    association :restriction
    association :unit
    association :ruleset
    man { 100 }
    mun { 90 }
    fuel { 40 }
    pop { 5 }
    resupply { 2 }
    resupply_max { 3 }
    company_max { 10 }
    priority { 1 }
  end
end


