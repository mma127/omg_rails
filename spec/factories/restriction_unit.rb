FactoryBot.define do
  factory :restriction_unit do
    association :restriction
    association :unit
    association :ruleset
    description { 'Restriction Unit' }
    man { 100 }
    mun { 90 }
    fuel { 40 }
    pop { 5 }
    resupply { 2 }
    resupply_max { 3 }
    company_max { 10 }
    type { "BaseRestrictionUnit" }
  end
end

