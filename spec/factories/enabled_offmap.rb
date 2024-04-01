FactoryBot.define do
  factory :enabled_offmap do
    association :restriction
    ruleset
    offmap { association :offmap, ruleset: ruleset }

    max { 10 }
    mun { 100 }
  end
end


