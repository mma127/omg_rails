# == Schema Information
#
# Table name: company_resource_bonuses
#
#  id                                :bigint           not null, primary key
#  level(Number of this bonus taken) :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  company_id                        :bigint
#  resource_bonus_id                 :bigint
#
# Indexes
#
#  index_company_resource_bonuses_on_company_id         (company_id)
#  index_company_resource_bonuses_on_resource_bonus_id  (resource_bonus_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (resource_bonus_id => resource_bonuses.id)
#
class CompanyResourceBonus < ApplicationRecord
  belongs_to :company
  belongs_to :resource_bonus
end
