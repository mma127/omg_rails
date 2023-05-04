# == Schema Information
#
# Table name: available_upgrade_units
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  available_upgrade_id :bigint
#  unit_id              :bigint
#
# Indexes
#
#  index_available_upgrade_units_on_available_upgrade_id  (available_upgrade_id)
#  index_available_upgrade_units_on_unit_id               (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (available_upgrade_id => available_upgrades.id)
#  fk_rails_...  (unit_id => units.id)
#
require "rails_helper"

RSpec.describe AvailableUpgradeUnit, type: :model do
  let!(:available_upgrade_unit) { create :available_upgrade_unit }

  describe 'associations' do
    it { should belong_to(:available_upgrade) }
    it { should belong_to(:unit) }
  end
end
