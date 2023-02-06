require "rails_helper"

RSpec.describe CompanyUnlock, type: :model do
  let!(:company_unlock) { create :company_unlock }

  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:doctrine_unlock) }
  end
end