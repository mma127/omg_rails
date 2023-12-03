# == Schema Information
#
# Table name: historical_player_ratings
#
#  id                                                 :bigint           not null, primary key
#  elo(trueskill mu normalized between 1000 and 2000) :integer
#  last_played(last played match)                     :date
#  mu(trueskill mu)                                   :decimal(, )
#  player_name(historical player name)                :string
#  sigma(trueskill sigma)                             :decimal(, )
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  player_id                                          :bigint
#
# Indexes
#
#  index_historical_player_ratings_on_player_id  (player_id)
#
require "rails_helper"

RSpec.describe HistoricalPlayerRating, type: :model do
  let!(:historical_player_rating) { create :historical_player_rating }

  describe 'associations' do
    it { should belong_to(:player).optional }
  end
end
