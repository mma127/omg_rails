FactoryBot.define do
  factory :battle_player do
    transient do
      ruleset { create :ruleset }
    end

    association :battle
    association :player
    company { association :company, ruleset: ruleset }
    side { "allied"}

    trait :axis do
      side { 'axis' }
    end
  end
end

