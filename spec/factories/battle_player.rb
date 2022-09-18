FactoryBot.define do
  factory :battle_player do
    association :battle
    association :player
    association :company
    side { "allied"}
  end
end

