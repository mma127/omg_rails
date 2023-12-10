FactoryBot.define do
  factory :historical_battle_player do
    association :player
    player_name { "" }
    sequence :battle_id do |n| "Battle #{n}" end
    association :faction
    association :doctrine
    is_winner { true }
    elo { 1500 }
    mu { 25.0 }
    sigma { 8.33333 }
    wins { 1 }
    losses { 0 }

    after(:create) do |hbp|
      hbp.update!(player_name: hbp.player.name)
    end
  end
end
