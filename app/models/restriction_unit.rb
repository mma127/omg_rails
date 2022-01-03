# == Schema Information
#
# Table name: restriction_units
#
#  id                                                                                    :bigint           not null, primary key
#  callin_modifier(Base callin modifier, default is 1)                                   :decimal(, )      default(1.0)
#  company_max(Maximum number of the unit a company can hold)                            :integer
#  description(What does this RestrictionUnit do?)                                       :string
#  fuel(Fuel cost)                                                                       :integer
#  man(Manpower cost)                                                                    :integer
#  mun(Munition cost)                                                                    :integer
#  pop(Population cost)                                                                  :decimal(, )
#  priority(Priority order to apply the modification from 1 -> 100)                      :integer
#  resupply(Per game resupply)                                                           :integer
#  resupply_max(How much resupply is available from saved up resupplies, <= company max) :integer
#  type(What effect this restriction has on the unit)                                    :string           not null
#  created_at                                                                            :datetime         not null
#  updated_at                                                                            :datetime         not null
#  restriction_id                                                                        :bigint
#  unit_id                                                                               :bigint
#
# Indexes
#
#  index_restriction_units_on_restriction_id              (restriction_id)
#  index_restriction_units_on_restriction_id_and_unit_id  (restriction_id,unit_id) UNIQUE
#  index_restriction_units_on_unit_id                     (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (unit_id => units.id)
#
class RestrictionUnit < ApplicationRecord
  belongs_to :restriction
  belongs_to :unit

  # enum types: {
  #   allow: "allow",
  #   disallow: "disallow"
  # }

  validates_numericality_of :man
  validates_numericality_of :mun
  validates_numericality_of :fuel
  validates_numericality_of :pop
  validates_numericality_of :callin_modifier
  validates_numericality_of :resupply
  validates_numericality_of :resupply_max
  validates_numericality_of :company_max
  validates_uniqueness_of :unit_id, scope: :restriction_id
end
