# == Schema Information
#
# Table name: company_unlocks
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id         :bigint
#  doctrine_unlock_id :bigint
#
# Indexes
#
#  index_company_unlocks_on_company_id          (company_id)
#  index_company_unlocks_on_doctrine_unlock_id  (doctrine_unlock_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (doctrine_unlock_id => doctrine_unlocks.id)
#
require "rails_helper"

RSpec.describe CompanyUnlock, type: :model do
  let!(:company) { create :company }
  let!(:doctrine_unlock) { create :doctrine_unlock, ruleset: company.ruleset }
  let!(:company_unlock) { create :company_unlock, company: company, doctrine_unlock: doctrine_unlock }

  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:doctrine_unlock) }
  end
end
