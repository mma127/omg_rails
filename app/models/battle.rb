# == Schema Information
#
# Table name: battles
#
#  id                         :bigint           not null, primary key
#  name(Optional battle name) :string
#  size(Size of each team)    :integer          not null
#  state(Battle status)       :string           not null
#  winner(Winning side)       :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  ruleset_id                 :bigint           not null
#
# Indexes
#
#  index_battles_on_ruleset_id  (ruleset_id)
#  index_battles_on_state       (state)
#
class Battle < ApplicationRecord
  belongs_to :ruleset
  has_many :battle_players, dependent: :destroy
  has_many :players, through: :battle_players
  has_many :companies, through: :battle_players
  has_many :squads, through: :companies

  has_one_attached :sga_file
  has_one_attached :ucs_file
  has_one_attached :zip_file

  validates_presence_of :ruleset
  validates_presence_of :size
  validates_numericality_of :size

  state_machine :state, initial: :open do
    event :full do
      transition :open => :full
    end

    event :not_full do
      transition :full => :open
    end

    event :ready do
      transition :full =>  :generating
    end

    event :generated do
      transition :generating => :ingame
    end

    event :reporting do
      transition :ingame => :reporting
    end

    event :revert_reporting do
      transition :reporting => :ingame
    end

    event :finalize do
      transition :reporting => :final
    end

    event :abandoned do
      transition [:open, :ingame, :reporting] => :abandoned
    end
  end

  def total_size
    size * 2
  end

  def players_full?
    battle_players.size == total_size
  end

  def players_ready?
    battle_players.all? { |bp| bp.ready }
  end

  def joinable
    state == "open"
  end

  def leavable
    %w[open full].include? state
  end

  def players_abandoned?
    battle_players.all? { |bp| bp.abandoned }
  end

  def abandonable
    %w[ingame reporting].include? state
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :size
    expose :state
    expose :ruleset_id, as: :rulesetId
    expose :winner

    expose :battle_players, as: :battlePlayers, using: BattlePlayer::Entity, if: {type: :include_players}
  end
end
