# == Schema Information
#
# Table name: units
#
#  id                                                        :bigint           not null, primary key
#  const_name(Const name of the unit for the battle file)    :string           not null
#  description(Display description of the unit)              :text
#  display_name(Display name)                                :string           not null
#  is_airdrop(Is this unit airdroppable?)                    :boolean          default(FALSE), not null
#  is_infiltrate(Is this unit able to infiltrate?)           :boolean          default(FALSE), not null
#  name(Unique unit name)                                    :string           not null
#  retreat_name(Name for retreating unit)                    :string
#  type(Unit type)                                           :string           not null
#  unitwide_upgrade_slots(Unit wide weapon replacement slot) :integer          default(0), not null
#  upgrade_slots(Slots used for per model weapon upgrades)   :integer          default(0), not null
#  created_at                                                :datetime         not null
#  updated_at                                                :datetime         not null
#
# Indexes
#
#  index_units_on_name  (name)
#
class Unit < ApplicationRecord
  belongs_to :restriction, optional: true

  has_many :unit_modifications
  has_many :unit_games
  has_many :games, through: :unit_games

  validates_presence_of :name
  validates_presence_of :const_name
  validates_presence_of :display_name
  validates_uniqueness_of :name
  validates_numericality_of :unitwide_upgrade_slots
  validates_numericality_of :upgrade_slots

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :display_name, as: :displayName
    expose :description
    expose :type
    expose :is_airdrop, as: :isAirdrop
    expose :is_infiltrate, as: :isInfiltrate
    expose :upgrade_slots, as: :upgradeSlots
    expose :unitwide_upgrade_slots, as: :unitwideUpgradeSlots
  end
end
