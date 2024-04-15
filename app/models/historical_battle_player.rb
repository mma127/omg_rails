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
#  ruleset_id                                                                            :bigint
#
# Indexes
#
#  index_historical_battle_players_on_doctrine_id  (doctrine_id)
#  index_historical_battle_players_on_faction_id   (faction_id)
#  index_historical_battle_players_on_player_id    (player_id)
#  index_historical_battle_players_on_player_name  (player_name)
#  index_historical_battle_players_on_ruleset_id   (ruleset_id)
#
# Foreign Keys
#
#  fk_rails_...  (ruleset_id => rulesets.id)
#
class HistoricalBattlePlayer < ApplicationRecord
  belongs_to :player, inverse_of: :historical_battle_players, optional: true
  belongs_to :faction
  belongs_to :doctrine
  belongs_to :ruleset

  def side
    faction.side
  end
end
