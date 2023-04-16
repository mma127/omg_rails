FactoryBot.define do
  factory :modified_replace_unit do
    association :restriction
    association :unit
    association :ruleset
  end
end


