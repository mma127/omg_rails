FactoryBot.define do
  factory :disabled_unit do
    association :restriction
    association :unit
    association :ruleset
    priority { 1 }
  end
end


