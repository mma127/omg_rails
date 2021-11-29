# == Schema Information
#
# Table name: unit_games
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint
#  unit_id    :bigint
#
# Indexes
#
#  index_unit_games_on_game_id  (game_id)
#  index_unit_games_on_unit_id  (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (unit_id => units.id)
#
class UnitGame < ApplicationRecord
  belongs_to :unit
  belongs_to :game
end
