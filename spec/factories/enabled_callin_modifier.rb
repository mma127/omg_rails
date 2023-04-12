FactoryBot.define do
  factory :enabled_callin_modifier do
    association :restriction
    association :callin_modifier
    association :ruleset
  end
end
