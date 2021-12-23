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

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :company_id, as: :companyId
    expose :unit_id, as: :unit_id
    expose :available
    expose :unit_name, as: :unitName
    expose :resupply
    expose :resupply_max, as: :resupplyMax
    expose :company_max, as: :companyMax
  end
end
