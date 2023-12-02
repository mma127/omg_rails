# == Schema Information
#
# Table name: historical_player_ratings
#
#  id                                                 :bigint           not null, primary key
#  elo(trueskill mu normalized between 1000 and 2000) :integer
#  mu(trueskill mu)                                   :decimal(, )
#  player_name(historical player name)                :string
#  sigma(trueskill sigma)                             :decimal(, )
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#
class HistoricalPlayerRating < ApplicationRecord

end
