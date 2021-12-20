# == Schema Information
#
# Table name: available_units
#
#  id                                                                   :bigint           not null, primary key
#  available(Number of this unit available to purchase for the company) :integer
#  created_at                                                           :datetime         not null
#  updated_at                                                           :datetime         not null
#  company_id                                                           :bigint
#  unit_id                                                              :bigint
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
end
