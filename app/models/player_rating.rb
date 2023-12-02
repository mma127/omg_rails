# == Schema Information
#
# Table name: player_ratings
#
#  id                                                 :bigint           not null, primary key
#  elo(trueskill mu normalized between 1000 and 2000) :integer
#  mu(trueskill mu)                                   :decimal(, )
#  sigma(trueskill sigma)                             :decimal(, )
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
class PlayerRating < ApplicationRecord
  belongs_to :player, inverse_of: :player_rating
end
