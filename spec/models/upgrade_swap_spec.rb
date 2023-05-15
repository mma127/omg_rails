# == Schema Information
#
# Table name: upgrade_swaps
#
#  id                                                             :bigint           not null, primary key
#  internal_description(Internal description of this UpgradeSwap) :string
#  created_at                                                     :datetime         not null
#  updated_at                                                     :datetime         not null
#  new_upgrade_id                                                 :bigint           not null
#  old_upgrade_id                                                 :bigint           not null
#  unlock_id                                                      :bigint           not null
#
# Indexes
#
#  index_upgrade_swaps_on_new_upgrade_id                (new_upgrade_id)
#  index_upgrade_swaps_on_old_upgrade_id                (old_upgrade_id)
#  index_upgrade_swaps_on_unlock_id                     (unlock_id)
#  index_upgrade_swaps_on_unlock_id_and_new_upgrade_id  (unlock_id,new_upgrade_id) UNIQUE
#  index_upgrade_swaps_on_unlock_id_and_old_upgrade_id  (unlock_id,old_upgrade_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (new_upgrade_id => upgrades.id)
#  fk_rails_...  (old_upgrade_id => upgrades.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#
require "rails_helper"

RSpec.describe UpgradeSwap, type: :model do
  let!(:upgrade_swap) { create :upgrade_swap }

  describe 'associations' do
    it { should belong_to(:unlock) }
    it { should belong_to(:old_upgrade) }
    it { should belong_to(:new_upgrade) }
    it { should have_many(:upgrade_swap_units) }
  end

  it "should construct a internal_description" do
    expect(upgrade_swap.internal_description)
      .to eq "#{upgrade_swap.unlock.display_name} | #{upgrade_swap.old_upgrade.display_name} -> #{upgrade_swap.new_upgrade.display_name}"
  end

  context "#unit_ids" do
    let!(:unit1) { create :unit }
    let!(:unit2) { create :unit }
    let!(:unit3) { create :unit }

    before do
      create :upgrade_swap_unit, upgrade_swap: upgrade_swap, unit: unit1
      create :upgrade_swap_unit, upgrade_swap: upgrade_swap, unit: unit2
      create :upgrade_swap_unit, upgrade_swap: upgrade_swap, unit: unit3
    end

    it "should return a list of unit ids associated with the upgrade swap" do
      expect(upgrade_swap.reload.unit_ids).to match_array [unit1.id, unit2.id, unit3.id]
    end
  end
end
