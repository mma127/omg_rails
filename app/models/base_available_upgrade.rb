# == Schema Information
#
# Table name: available_upgrades
#
#  id                                                               :bigint           not null, primary key
#  fuel(Calculated fuel cost of this upgrade for the company)       :integer          not null
#  man(Calculated man cost of this upgrade for the company)         :integer          not null
#  max(Maximum number of this upgrade purchasable by a unit)        :integer
#  mun(Calculated mun cost of this upgrade for the company)         :integer          not null
#  pop(Calculated pop cost of this upgrade for the company)         :decimal(, )      not null
#  type(Type of available upgrade)                                  :string           not null
#  unitwide_upgrade_slots(Upgrade slot cost for unit wide upgrades) :integer
#  upgrade_slots(Upgrade slot cost for per model upgrades)          :integer
#  uses(Uses of this upgrade)                                       :integer
#  created_at                                                       :datetime         not null
#  updated_at                                                       :datetime         not null
#  company_id                                                       :bigint
#  unit_id                                                          :bigint
#  upgrade_id                                                       :bigint
#
# Indexes
#
#  idx_available_upgrade_uniq              (company_id,upgrade_id,unit_id,type) UNIQUE
#  index_available_upgrades_on_company_id  (company_id)
#  index_available_upgrades_on_unit_id     (unit_id)
#  index_available_upgrades_on_upgrade_id  (upgrade_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (unit_id => units.id)
#  fk_rails_...  (upgrade_id => upgrades.id)
#
class BaseAvailableUpgrade < AvailableUpgrade

end
