# == Schema Information
#
# Table name: available_offmaps
#
#  id                                                                     :bigint           not null, primary key
#  available(Number of this offmap available to purchase for the company) :integer          default(0), not null
#  max(Max number of this offmap that the company can hold)               :integer          default(0), not null
#  mun(Munitions cost of this offmap)                                     :integer          default(0), not null
#  created_at                                                             :datetime         not null
#  updated_at                                                             :datetime         not null
#  company_id                                                             :bigint
#  offmap_id                                                              :bigint
#
# Indexes
#
#  index_available_offmaps_on_company_id  (company_id)
#  index_available_offmaps_on_offmap_id   (offmap_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (offmap_id => offmaps.id)
#
require "rails_helper"

RSpec.describe AvailableOffmap, type: :model do
  let!(:available_offmap) { create :available_offmap }

  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:offmap) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:available).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:max).is_greater_than_or_equal_to(0) }
  end

  describe 'scopes' do
    describe 'offmap_active' do
      let(:ruleset) { create :ruleset }
      let(:offmap) { create :offmap, ruleset: ruleset }
      let(:available_offmap) { create :available_offmap, offmap: offmap, ruleset: ruleset }

      subject { described_class.offmap_active }

      it { should include available_offmap }

      context "when the offmap is disabled" do
        let(:offmap) { create :offmap, ruleset: ruleset, disabled: true }

        it { should_not include available_offmap }
      end
    end
  end
end
