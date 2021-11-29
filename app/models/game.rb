# == Schema Information
#
# Table name: games
#
#  id              :bigint           not null, primary key
#  name(Game name) :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Game < ApplicationRecord

  has_many :unit_games
  has_many :unit, through: :unit_games
end
