# == Schema Information
#
# Table name: player_discord_temp
#
#  id          :bigint           not null, primary key
#  player_name :string
#  discord_id  :string
#
class PlayerDiscordTemp < ApplicationRecord
  self.table_name = 'player_discord_temp'
end
