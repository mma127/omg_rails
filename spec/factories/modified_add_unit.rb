FactoryBot.define do
  factory :modified_add_unit do
    association :restriction
    association :unit
    association :ruleset
  end
end
