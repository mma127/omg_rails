# == Schema Information
#
# Table name: restriction_upgrade_units
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  restriction_upgrade_id :bigint
#  unit_id                :bigint
#
# Indexes
#
#  index_restriction_upgrade_units_on_restriction_upgrade_id  (restriction_upgrade_id)
#  index_restriction_upgrade_units_on_unit_id                 (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (restriction_upgrade_id => restriction_upgrades.id)
#  fk_rails_...  (unit_id => units.id)
#
require "rails_helper"

RSpec.describe RestrictionUpgradeUnit, type: :model do
  let!(:restriction_upgrade_unit) { create :restriction_upgrade_unit }

  describe 'associations' do
    it { should belong_to(:restriction_upgrade) }
    it { should belong_to(:unit) }
  end

  describe "#allowed?" do
    subject { restriction_upgrade_unit.allowed? }

    it { should eq true }
  end
end
