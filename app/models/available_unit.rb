# == Schema Information
#
# Table name: available_units
#
#  id                                                                                   :bigint           not null, primary key
#  available(Number of this unit available to purchase for the company)                 :integer
#  company_max(Maximum number of the unit a company can hold)                           :integer          not null
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
  # def unit_type
  #   unit.type
  # end
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
    # expose :unit_type, as: :unitType
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
