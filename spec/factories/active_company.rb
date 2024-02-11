FactoryBot.define do
  factory :active_company do
    association :faction
    association :doctrine
    association :player
    association :ruleset
    name { "Company name" }
    sequence :uuid do |n| "active uuid #{n}" end
    vps_earned { 0 }
    vps_current { 0 }
    pop { 0 }
    man { 7000 }
    mun { 1600 }
    fuel { 1400 }
  end
end

