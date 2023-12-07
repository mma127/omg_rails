FactoryBot.define do
  factory :battle_player do
    association :battle
    association :player
    association :company
    side { "allied"}

    trait :axis do
      side { 'axis' }
    end
  end
end

