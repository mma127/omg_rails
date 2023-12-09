FactoryBot.define do
  factory :player_rating do
    association :player
    elo { 1500 }
    mu { 25.0 }
    sigma { 8.33333 }
    wins { 0 }
    losses { 0 }
  end
end
