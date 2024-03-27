# == Schema Information
#
# Table name: battle_players
#
#  id                                      :bigint           not null, primary key
#  abandoned(Is this player abandoning?)   :boolean          default(FALSE)
#  is_dropped(Has this player dropped?)    :boolean          default(FALSE)
#  ready(Ready flag for the player)        :boolean          default(FALSE)
#  side(Team side)                         :string           not null
#  team_balance(Assigned team for balance) :integer
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  battle_id                               :bigint           not null
#  company_id                              :bigint           not null
#  player_id                               :bigint           not null
#
# Indexes
#
#  index_battle_players_on_battle_id   (battle_id)
#  index_battle_players_on_company_id  (company_id)
#  index_battle_players_on_player_id   (player_id)
#
class BattlePlayer < ApplicationRecord
  belongs_to :battle, inverse_of: :battle_players, touch: true # touch to update battle updated_at
  belongs_to :player
  belongs_to :company

  validates_presence_of :battle
  validates_presence_of :player
  validates_presence_of :company

  after_destroy -> { battle.touch } # For some reason :touch is not triggering on destroy, do it manually

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

  def player_elo
    player.player_rating.elo
  end

  def win?
    side == battle.winner
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :battle_id, as: :battleId
    expose :player_id, as: :playerId
    expose :player_name, as: :playerName
    expose :player_elo, as: :playerElo
    expose :company_id, as: :companyId
    expose :side
    expose :abandoned
    expose :company_doctrine, as: :companyDoctrine
    expose :ready
    expose :team_balance, as: :teamBalance
  end

  def history_entity
    HistoryEntity.new(self)
  end

  class HistoryEntity < Grape::Entity
    expose :player_id, as: :playerId
    expose :player_name, as: :playerName
    expose :side
    # TODO Can't expose company values as companies may have been deleted. Instead we should probably save the doctrine name to the BattlePlayer record
    # expose :company_id, as: :companyId
    # expose :company_doctrine, as: :companyDoctrine
  end
end
