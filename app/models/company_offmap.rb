# == Schema Information
#
# Table name: company_offmaps
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint
#  offmap_id  :bigint
#
# Indexes
#
#  index_company_offmaps_on_company_id  (company_id)
#  index_company_offmaps_on_offmap_id   (offmap_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (offmap_id => offmaps.id)
#
class CompanyOffmap < ApplicationRecord
  belongs_to :company
  belongs_to :offmap
end
