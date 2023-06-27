FactoryBot.define do
  factory :enabled_upgrade do
    association :restriction
    association :upgrade
    association :ruleset
    man { 100 }
    mun { 90 }
    fuel { 40 }
    pop { 5 }
    uses { 2 }
    unitwide_upgrade_slots { nil }
    upgrade_slots { nil }
    priority { 1 }
  end
end


