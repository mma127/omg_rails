# == Schema Information
#
# Table name: callin_modifiers
#
#  id                                                                 :bigint           not null, primary key
#  modifier(Modifies callin time)                                     :decimal(, )
#  priority(Priority in which the modifier is applied, from 1 -> 100) :integer
#  type(Type of modification)                                         :string
#  created_at                                                         :datetime         not null
#  updated_at                                                         :datetime         not null
#
class CallinModifier < ApplicationRecord

  has_many :callin_modifier_required_units
  has_many :required_units, through: :callin_modifier_required_units, class_name: "Unit"
  has_many :callin_modifier_allowed_units
  has_many :allowed_units, through: :callin_modifier_allowed_units, class_name: "Unit"
end
