# == Schema Information
#
# Table name: company_unlocks
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint
#  unlock_id  :bigint
#
# Indexes
#
#  index_company_unlocks_on_company_id  (company_id)
#  index_company_unlocks_on_unlock_id   (unlock_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#
class CompanyUnlock < ApplicationRecord
  belongs_to :company
  belongs_to :unlock
end
