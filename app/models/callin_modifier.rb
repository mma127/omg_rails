# == Schema Information
#
# Table name: callin_modifiers
#
#  id                                                                   :bigint           not null, primary key
#  description(Description)                                             :string
#  modifier(Modifies callin time)                                       :decimal(, )
#  modifier_type(Type of modification)                                  :string
#  priority(Priority in which the modifier is applied, from 1 -> 100)   :integer
#  unlock_name(Name of the unlock associated with this callin modifier) :string
#  created_at                                                           :datetime         not null
#  updated_at                                                           :datetime         not null
#
class CallinModifier < ApplicationRecord
  has_many :restriction_callin_modifiers
  has_many :callin_modifier_required_units
  has_many :required_units, through: :callin_modifier_required_units, class_name: "Unit"
  has_many :callin_modifier_allowed_units
  has_many :allowed_units, through: :callin_modifier_allowed_units, class_name: "Unit"

  validates_presence_of :modifier
  validates_presence_of :modifier_type
  validates_presence_of :priority
  validates_numericality_of :modifier

  enum modifier_type: {
    multiplicative: "multiplicative"
  }

  def no_required?
    callin_modifier_required_units.empty?
  end
  def any_allowed?
    callin_modifier_allowed_units.empty?
  end

  def required_unit_ids
    callin_modifier_required_units.pluck(:unit_id)
  end

  def required_unit_names
    callin_modifier_required_units.pluck(:unit_name).sort.join(", ")
  end

  def allowed_unit_ids
    callin_modifier_allowed_units.pluck(:unit_id)
  end

  def allowed_unit_names
    callin_modifier_allowed_units.pluck(:unit_name).sort.join(", ")
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :description
    expose :unlock_name, as: :unlockName
    expose :modifier
    expose :modifier_type, as: :modifierType
    expose :required_unit_ids, as: :requiredUnitIds
    expose :allowed_unit_ids, as: :allowedUnitIds
    expose :required_unit_names, as: :requiredUnitNames
    expose :allowed_unit_names, as: :allowedUnitNames
  end
end
