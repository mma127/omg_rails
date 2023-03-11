FactoryBot.define do
  factory :enabled_offmap do
    association :restriction
    association :offmap
    association :ruleset
    max { 10 }
    mun { 100 }
  end
end


