# == Schema Information
#
# Table name: historical_player_ratings
#
#  id                                                 :bigint           not null, primary key
#  elo(trueskill mu normalized between 1000 and 2000) :integer
#  last_played(last played match)                     :date
#  losses(losses to date)                             :integer          default(0)
#  mu(trueskill mu)                                   :float
#  player_name(historical player name)                :string
#  sigma(trueskill sigma)                             :float
#  wins(wins to date)                                 :integer          default(0)
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  player_id                                          :bigint
#
# Indexes
#
#  index_historical_player_ratings_on_player_id    (player_id)
#  index_historical_player_ratings_on_player_name  (player_name) UNIQUE
#
require "rails_helper"

RSpec.describe HistoricalPlayerRating, type: :model do
  let!(:historical_player_rating) { create :historical_player_rating }

  describe 'associations' do
    it { should belong_to(:player).optional }
  end
end
