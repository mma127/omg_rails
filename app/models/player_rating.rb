# == Schema Information
#
# Table name: player_ratings
#
#  id                                                 :bigint           not null, primary key
#  elo(trueskill mu normalized between 1000 and 2000) :integer
#  last_played(last played match)                     :date
#  losses(losses to date)                             :integer          default(0)
#  mu(trueskill mu)                                   :float
#  sigma(trueskill sigma)                             :float
#  wins(wins to date)                                 :integer          default(0)
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  player_id                                          :bigint
#
# Indexes
#
#  index_player_ratings_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (player_id => players.id)
#
require 'saulabs/trueskill'

include Saulabs::TrueSkill

class PlayerRating < ApplicationRecord
  DEFAULT_ELO = 1500
  DEFAULT_MU = 25.0
  DEFAULT_SIGMA = 25.0 / 3.0

  belongs_to :player, inverse_of: :player_rating

  def self.from_historical(player, hpr)
    PlayerRating.create!(player: player, elo: hpr.elo, mu: hpr.mu, sigma: hpr.sigma, last_played: hpr.last_played)
  end

  def self.for_new_player(player)
    PlayerRating.create!(player: player, elo: DEFAULT_ELO, mu: DEFAULT_MU, sigma: DEFAULT_SIGMA, last_played: nil)
  end

  def weeks_since_last_played(now = DateTime.now)
    # First game, don't worry about time gap
    if last_played.blank?
      return 0
    end

    delta = now - last_played
    (delta / 7).to_i
  end

  def ts_rating
    Ratings::NamedRating.new(player.name, mu, sigma)
  end
end
