# == Schema Information
#
# Table name: unit_swaps
#
#  id                                        :bigint           not null, primary key
#  description(Description of this UnitSwap) :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  new_unit_id                               :bigint           not null
#  old_unit_id                               :bigint           not null
#  unlock_id                                 :bigint           not null
#
# Indexes
#
#  index_unit_swaps_on_new_unit_id                (new_unit_id)
#  index_unit_swaps_on_old_unit_id                (old_unit_id)
#  index_unit_swaps_on_unlock_id                  (unlock_id)
#  index_unit_swaps_on_unlock_id_and_old_unit_id  (unlock_id,old_unit_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (new_unit_id => units.id)
#  fk_rails_...  (old_unit_id => units.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#
require "rails_helper"

RSpec.describe UnitSwap, type: :model do
  let!(:unit_swap) { create :unit_swap}

  describe 'associations' do
    it { should belong_to(:unlock) }
    it { should belong_to(:old_unit) }
    it { should belong_to(:new_unit) }
  end

  it "should construct a description" do
    expect(unit_swap.description)
      .to eq "#{unit_swap.unlock.display_name} | #{unit_swap.old_unit.display_name} -> #{unit_swap.new_unit.display_name}"
  end
end
