# == Schema Information
#
# Table name: available_upgrades
#
#  id                                                                                    :bigint           not null, primary key
#  available(Number of this upgrade available to purchase for the company)               :integer
#  company_max(Maximum number of the unit a company can hold)                            :integer
#  fuel(Calculated fuel cost of this upgrade for the company)                            :integer          not null
#  man(Calculated man cost of this upgrade for the company)                              :integer          not null
#  mun(Calculated mun cost of this upgrade for the company)                              :integer          not null
#  pop(Calculated pop cost of this upgrade for the company)                              :decimal(, )      not null
#  resupply(Per game resupply)                                                           :integer
#  resupply_max(How much resupply is available from saved up resupplies, <= company max) :integer
#  type(Type of available upgrade)                                                       :string           not null
#  created_at                                                                            :datetime         not null
#  updated_at                                                                            :datetime         not null
#  company_id                                                                            :bigint
#  upgrade_id                                                                            :bigint
#
# Indexes
#
#  index_available_upgrades_on_company_id                          (company_id)
#  index_available_upgrades_on_company_id_and_upgrade_id_and_type  (company_id,upgrade_id,type) UNIQUE
#  index_available_upgrades_on_upgrade_id                          (upgrade_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (upgrade_id => upgrades.id)
#
class BaseAvailableUpgrade < AvailableUpgrade

end
