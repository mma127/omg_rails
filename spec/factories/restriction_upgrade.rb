FactoryBot.define do
  factory :restriction_upgrade do
    association :restriction
    association :upgrade
    association :ruleset
    internal_description { 'Restriction Upgrade' }
    uses { 1 }
    man { 100 }
    mun { 90 }
    fuel { 40 }
    pop { 5 }
    priority { 1 }
    unitwide_upgrade_slots { nil }
    upgrade_slots { nil }
    type { "EnabledUpgrade" }
  end
end

