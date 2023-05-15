# == Schema Information
#
# Table name: upgrade_swap_units
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  unit_id         :bigint           not null
#  upgrade_swap_id :bigint           not null
#
# Indexes
#
#  index_upgrade_swap_units_on_unit_id                      (unit_id)
#  index_upgrade_swap_units_on_upgrade_swap_id              (upgrade_swap_id)
#  index_upgrade_swap_units_on_upgrade_swap_id_and_unit_id  (upgrade_swap_id,unit_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (unit_id => units.id)
#  fk_rails_...  (upgrade_swap_id => upgrade_swaps.id)
#
require 'rails_helper'

RSpec.describe UpgradeSwapUnit, type: :model do
  let!(:upgrade_swap_unit) { create :upgrade_swap_unit }

  describe 'associations' do
    it { should belong_to(:upgrade_swap) }
    it { should belong_to(:unit) }
  end

  describe 'validations' do
    it { should validate_presence_of(:upgrade_swap) }
    it { should validate_presence_of(:unit) }
    it { should validate_uniqueness_of(:unit).scoped_to(:upgrade_swap_id) }
  end
end
