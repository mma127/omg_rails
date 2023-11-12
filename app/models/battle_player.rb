# == Schema Information
#
# Table name: battle_players
#
#  id                                    :bigint           not null, primary key
#  abandoned(Is this player abandoning?) :boolean
#  side(Team side)                       :string           not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  battle_id                             :bigint           not null
#  company_id                            :bigint           not null
#  player_id                             :bigint           not null
#
# Indexes
#
#  index_battle_players_on_battle_id   (battle_id)
#  index_battle_players_on_company_id  (company_id)
#  index_battle_players_on_player_id   (player_id)
#
class BattlePlayer < ApplicationRecord
  belongs_to :battle
  belongs_to :player
  belongs_to :company

  validates_presence_of :battle
  validates_presence_of :player
  validates_presence_of :company

  enum side: {
    allied: "allied",
    axis: "axis"
  }

  scope :in_active_battle, -> { joins(:battle).where.not(battle: { state: %w[final abandoned] }) }

  def player_name
    player.name
  end

  def company_doctrine
    company.doctrine.name
  end

  def entity
    Entity.new(self)
  end

  def abandoned?
    abandoned
  end

  class Entity < Grape::Entity
    expose :id
    expose :battle_id, as: :battleId
    expose :player_id, as: :playerId
    expose :player_name, as: :playerName
    expose :company_id, as: :companyId
    expose :side
    expose :abandoned
    expose :company_doctrine, as: :companyDoctrine
    expose :ready
  end
end
