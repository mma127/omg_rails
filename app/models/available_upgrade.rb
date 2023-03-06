# == Schema Information
#
# Table name: available_upgrades
#
#  id                                                                      :bigint           not null, primary key
#  available(Number of this upgrade available to purchase for the company) :integer
#  created_at                                                              :datetime         not null
#  updated_at                                                              :datetime         not null
#  company_id                                                              :bigint
#  upgrade_id                                                              :bigint
#
# Indexes
#
#  index_available_upgrades_on_company_id  (company_id)
#  index_available_upgrades_on_upgrade_id  (upgrade_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (upgrade_id => upgrades.id)
#
class AvailableUpgrade < ApplicationRecord
  belongs_to :company
  belongs_to :upgrade

  has_many :squad_upgrades
end
