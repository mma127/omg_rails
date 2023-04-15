# == Schema Information
#
# Table name: callin_modifier_required_units
#
#  id                                                  :bigint           not null, primary key
#  unit_name(Denormalized unit name for faster access) :string
#  created_at                                          :datetime         not null
#  updated_at                                          :datetime         not null
#  callin_modifier_id                                  :bigint
#  unit_id                                             :bigint
#
# Indexes
#
#  index_callin_modifier_required_units_on_callin_modifier_id  (callin_modifier_id)
#  index_callin_modifier_required_units_on_unit_id             (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (callin_modifier_id => callin_modifiers.id)
#  fk_rails_...  (unit_id => units.id)
#
class CallinModifierRequiredUnit < ApplicationRecord
  belongs_to :callin_modifier
  belongs_to :unit

  validates_presence_of :callin_modifier
  validates_presence_of :unit

  before_save :save_unit_name

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :callin_modifier_id, as: :callinModifierId
    expose :unit_id, as: :unitId
    expose :unit_name, as: :unitName
  end

  private

  def save_unit_name
    self.unit_name = unit.display_name
  end
end

