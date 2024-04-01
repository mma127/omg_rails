FactoryBot.define do
  factory :restriction_offmap do
    association :restriction
    ruleset
    offmap { association :offmap, ruleset: ruleset }

    internal_description { 'Restriction Offmap' }
    mun { 90 }
    max { 10 }
    type { "EnabledOffmap" }
  end
end

