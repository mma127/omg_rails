# == Schema Information
#
# Table name: historical_battle_players
#
#  id                                                                                    :bigint           not null, primary key
#  date(date of the battle)                                                              :date
#  elo(Trueskill mu normalized, after battle)                                            :integer
#  is_winner(Whether the player won)                                                     :boolean          not null
#  losses(losses to date)                                                                :integer          default(0)
#  mu(Trueskill mu, after battle)                                                        :float
#  player_name(Denormalized player name in case player record is deleted)                :string           not null
#  sigma(Trueskill sigma, after battle)                                                  :float
#  wins(wins to date)                                                                    :integer          default(0)
#  created_at                                                                            :datetime         not null
#  updated_at                                                                            :datetime         not null
#  battle_id(Battle id, could be duplicates in the long run through multiple war resets) :string           not null
#  doctrine_id                                                                           :bigint           not null
#  faction_id                                                                            :bigint           not null
#  player_id                                                                             :bigint
#
# Indexes
#
#  index_historical_battle_players_on_doctrine_id  (doctrine_id)
#  index_historical_battle_players_on_faction_id   (faction_id)
#  index_historical_battle_players_on_player_id    (player_id)
#  index_historical_battle_players_on_player_name  (player_name)
#
require "rails_helper"

RSpec.describe HistoricalBattlePlayer, type: :model do
  let!(:historical_battle_player) { create :historical_battle_player }

  describe 'associations' do
    it { should belong_to(:player).optional }
    it { should belong_to(:faction) }
    it { should belong_to(:doctrine) }
  end
end
