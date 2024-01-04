# == Schema Information
#
# Table name: player_discord_temp
#
#  id          :bigint           not null, primary key
#  player_name :string
#  discord_id  :string
#
FactoryBot.define do
  factory :player_discord_temp do
    player_name { "player" }
    discord_id { 123456 }
  end
end
