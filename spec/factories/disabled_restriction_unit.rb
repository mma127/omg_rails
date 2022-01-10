FactoryBot.define do
  factory :disabled_restriction_unit do
    association :restriction
    association :unit
    association :ruleset
    priority { 1 }
  end
end


