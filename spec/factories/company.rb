FactoryBot.define do
  factory :company do
    association :faction
    association :doctrine
    association :player
    association :ruleset
    name { "Company name" }
    vps_earned { 0 }
    pop { 0 }
    man { 7000 }
    mun { 1600 }
    fuel { 1400 }
  end
end

