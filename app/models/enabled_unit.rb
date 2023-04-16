# == Schema Information
#
# Table name: restriction_units
#
#  id                                                                                    :bigint           not null, primary key
#  callin_modifier(Base callin modifier)                                                 :decimal(, )
#  company_max(Maximum number of the unit a company can hold)                            :integer
#  fuel(Fuel cost)                                                                       :integer
#  internal_description(What does this RestrictionUnit do?)                              :string           not null
#  man(Manpower cost)                                                                    :integer
#  mun(Munition cost)                                                                    :integer
#  pop(Population cost)                                                                  :decimal(, )
#  priority(Priority order to apply the modification from 1 -> 100)                      :integer
#  resupply(Per game resupply)                                                           :integer
#  resupply_max(How much resupply is available from saved up resupplies, <= company max) :integer
#  type(What effect this restriction has on the unit)                                    :string           not null
#  unitwide_upgrade_slots(Unit wide weapon replacement slot)                             :integer
#  upgrade_slots(Slots used for per model weapon upgrades)                               :integer
#  created_at                                                                            :datetime         not null
#  updated_at                                                                            :datetime         not null
#  restriction_id                                                                        :bigint
#  ruleset_id                                                                            :bigint
#  unit_id                                                                               :bigint
#
# Indexes
#
#  index_restriction_units_on_restriction_id                 (restriction_id)
#  index_restriction_units_on_restriction_id_and_ruleset_id  (restriction_id,ruleset_id)
#  index_restriction_units_on_ruleset_id                     (ruleset_id)
#  index_restriction_units_on_unit_id                        (unit_id)
#  index_restriction_units_on_unit_id_and_ruleset_id         (unit_id,ruleset_id)
#  index_restriction_units_restriction_unit_ruleset_type     (restriction_id,unit_id,ruleset_id,type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (ruleset_id => rulesets.id)
#  fk_rails_...  (unit_id => units.id)
#
class EnabledUnit < RestrictionUnit
  validates_numericality_of :man
  validates_numericality_of :mun
  validates_numericality_of :fuel
  validates_numericality_of :pop
  validates_numericality_of :callin_modifier
  validates_numericality_of :resupply
  validates_numericality_of :resupply_max
  validates_numericality_of :company_max

  before_save :generate_internal_description
  after_initialize :set_defaults

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :internal_description, as: :internalDescription
    expose :man
    expose :mun
    expose :fuel
    expose :pop
    expose :resupply
    expose :unit, using: Unit::Entity
  end

  private

  def set_defaults
    self.callin_modifier ||= 1
    self.upgrade_slots ||= 0
    self.unitwide_upgrade_slots ||= 0
  end

  def generate_internal_description
    self.internal_description = "#{restriction.name} - #{unit.display_name}"
  end
end
