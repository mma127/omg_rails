# == Schema Information
#
# Table name: units
#
#  id                                                              :bigint           not null, primary key
#  const_name(Const name of the unit for the battle file)          :string           not null
#  description(Display description of the unit)                    :text
#  display_name(Display name)                                      :string           not null
#  is_airdrop(Is this unit airdroppable?)                          :boolean          default(FALSE), not null
#  is_infiltrate(Is this unit able to infiltrate?)                 :boolean          default(FALSE), not null
#  model_count(How many model entities this base unit consists of) :integer
#  name(Unique unit name)                                          :string           not null
#  retreat_name(Name for retreating unit)                          :string
#  transport_model_slots(How many models this unit can transport)  :integer
#  transport_squad_slots(How many squads this unit can transport)  :integer
#  type(Unit type)                                                 :string           not null
#  unitwide_upgrade_slots(Unit wide weapon replacement slot)       :integer          default(0), not null
#  upgrade_slots(Slots used for per model weapon upgrades)         :integer          default(0), not null
#  created_at                                                      :datetime         not null
#  updated_at                                                      :datetime         not null
#
# Indexes
#
#  index_units_on_name  (name) UNIQUE
#
class Unit < ApplicationRecord
  has_many :restriction_units
  has_one :unit_vet, inverse_of: :unit
  has_many :unit_games
  has_many :games, through: :unit_games
  has_many :transport_allowed_units, foreign_key: "transport_id"

  validates_presence_of :name
  validates_presence_of :const_name
  validates_presence_of :display_name
  validates_uniqueness_of :name
  validates_numericality_of :unitwide_upgrade_slots
  validates_numericality_of :upgrade_slots

  def transportable_unit_ids
    transport_allowed_units.pluck(:allowed_unit_id)
  end

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
    expose :model_count, as: :modelCount
    expose :transport_squad_slots, as: :transportSquadSlots
    expose :transport_model_slots, as: :transportModelSlots
    expose :transportable_unit_ids, as: :transportableUnitIds
  end
end
