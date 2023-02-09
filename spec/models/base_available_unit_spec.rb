# == Schema Information
#
# Table name: available_units
#
#  id                                                                                   :bigint           not null, primary key
#  available(Number of this unit available to purchase for the company)                 :integer          default(0), not null
#  callin_modifier(Calculated base callin modifier of this unit for the company)        :decimal(, )      not null
#  company_max(Maximum number of the unit a company can hold)                           :integer          default(0), not null
#  fuel(Calculated fuel cost of this unit for the company)                              :integer          not null
#  man(Calculated man cost of this unit for the company)                                :integer          not null
#  mun(Calculated mun cost of this unit for the company)                                :integer          not null
#  pop(Calculated pop cost of this unit for the company)                                :decimal(, )      not null
#  resupply(Per game resupply)                                                          :integer          default(0), not null
#  resupply_max(How much resupply is available from saved up resupplies, <= company ma) :integer          default(0), not null
#  type(Type of available unit)                                                         :string           not null
#  created_at                                                                           :datetime         not null
#  updated_at                                                                           :datetime         not null
#  company_id                                                                           :bigint
#  unit_id                                                                              :bigint
#
# Indexes
#
#  index_available_units_on_company_id                       (company_id)
#  index_available_units_on_company_id_and_unit_id_and_type  (company_id,unit_id,type) UNIQUE
#  index_available_units_on_unit_id                          (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (unit_id => units.id)
#
RSpec.describe BaseAvailableUnit, type: :model do
  let!(:base_available_unit) { create :base_available_unit}
end
