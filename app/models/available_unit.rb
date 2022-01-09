# == Schema Information
#
# Table name: available_units
#
#  id                                                                                   :bigint           not null, primary key
#  available(Number of this unit available to purchase for the company)                 :integer
#  callin_modifier(Calculated base callin modifier of this unit for the company)        :decimal(, )      not null
#  company_max(Maximum number of the unit a company can hold)                           :integer          not null
#  fuel(Calculated fuel cost of this unit for the company)                              :integer          not null
#  man(Calculated man cost of this unit for the company)                                :integer          not null
#  mun(Calculated mun cost of this unit for the company)                                :integer          not null
#  pop(Calculated pop cost of this unit for the company)                                :decimal(, )      not null
#  resupply(Per game resupply)                                                          :integer          not null
#  resupply_max(How much resupply is available from saved up resupplies, <= company ma) :integer          not null
#  created_at                                                                           :datetime         not null
#  updated_at                                                                           :datetime         not null
#  company_id                                                                           :bigint
#  unit_id                                                                              :bigint
#
# Indexes
#
#  index_available_units_on_company_id  (company_id)
#  index_available_units_on_unit_id     (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (unit_id => units.id)
#
class AvailableUnit < ApplicationRecord
  belongs_to :company
  belongs_to :unit
  has_many :squads
  delegate :ruleset, to: :company

  validates_presence_of :company
  validates_presence_of :unit
  validates_presence_of :available
  validates_presence_of :resupply
  validates_presence_of :resupply_max
  validates_presence_of :company_max
  validates_presence_of :pop
  validates_presence_of :man
  validates_presence_of :mun
  validates_presence_of :fuel
  validates_presence_of :callin_modifier
  validates_numericality_of :available, greater_than_or_equal_to: 0
  validates_numericality_of :resupply, greater_than_or_equal_to: 0
  validates_numericality_of :resupply_max, greater_than_or_equal_to: 0
  validates_numericality_of :company_max, greater_than_or_equal_to: 0
  validates_numericality_of :pop, greater_than_or_equal_to: 0
  validates_numericality_of :man, greater_than_or_equal_to: 0
  validates_numericality_of :mun, greater_than_or_equal_to: 0
  validates_numericality_of :fuel, greater_than_or_equal_to: 0
  validates_numericality_of :callin_modifier, greater_than_or_equal_to: 0

  def unit_name
    unit.name
  end

  def unit_display_name
    unit.display_name
  end
  #
  # def unit_description
  #   unit.description
  # end
  #
  def unit_type
    unit.type
  end
  #
  # def unit_upgrade_slots
  #   unit.upgrade_slots
  # end
  #
  # def unit_unitwide_upgrade_slots
  #   unit.unitwide_upgrade_slots
  # end
  #
  # def unit_is_airdrop
  #   unit.is_airdrop
  # end
  #
  # def unit_is_infiltrate
  #   unit.is_infiltrate
  # end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :company_id, as: :companyId
    expose :unit_id, as: :unitId
    expose :unit_name, as: :unitName
    expose :unit_display_name, as: :unitDisplayName
    # expose :unit_description, as: :unitDescription
    expose :unit_type, as: :unitType
    # expose :unit_upgrade_slots, as: :unitUpgradeSlots
    # expose :unit_unitwide_upgrade_slots, as: :unitUnitwideUpgradeSlots
    # expose :unit_is_airdrop, as: :unitIsAirdrop
    # expose :unit_is_infiltrate, as: :unitIsInfiltrate
    expose :available
    expose :resupply
    expose :resupply_max, as: :resupplyMax
    expose :company_max, as: :companyMax
    expose :pop
    expose :man
    expose :mun
    expose :fuel
    expose :callin_modifier, as: :callinModifier
  end
end
