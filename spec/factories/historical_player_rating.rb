FactoryBot.define do
  factory :historical_player_rating do
    sequence :player_name do |n| "Player #{n}".upcase end
    elo { 1500 }
    mu { 25.0 }
    sigma { 8.33333 }
  end
end
