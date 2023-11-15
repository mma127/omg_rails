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
class RestrictionUnit < ApplicationRecord
  MODIFY_FIELDS = [:man, :mun, :fuel, :pop, :callin_modifier, :resupply, :resupply_max, :company_max, :upgrade_slots, :unitwide_upgrade_slots].freeze
  MODIFY_CLASSES = %w[ModifiedReplaceUnit ModifiedAddUnit].freeze

  belongs_to :restriction
  belongs_to :unit
  belongs_to :ruleset

  scope :modified, -> { where(type: RestrictionUnit::MODIFY_CLASSES)}

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
    expose :resupply_max, as: :resupplyMax
    expose :company_max, as: :companyMax
    expose :callin_modifier, as: :callinModifier
    expose :upgrade_slots, as: :upgradeSlots
    expose :unitwide_upgrade_slots, as: :unitwideUpgradeSlots
    expose :unit, using: Unit::Entity
    expose :restriction, using: Restriction::Entity, if: { type: :include_restriction }
    expose :priority
    expose :type
  end
end
