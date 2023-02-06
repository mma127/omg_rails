# == Schema Information
#
# Table name: doctrine_unlocks
#
#  id                                                                    :bigint           not null, primary key
#  branch(Which branch of the doctrine tree this unlock will appear at)  :integer
#  row(Which row of the doctrine tree branch this unlock will appear at) :integer
#  tree(Which tree of the doctrine this unlock will appear at)           :integer
#  vp_cost(VP cost of this doctrine unlock)                              :integer          default(0), not null
#  created_at                                                            :datetime         not null
#  updated_at                                                            :datetime         not null
#  doctrine_id                                                           :bigint
#  unlock_id                                                             :bigint
#
# Indexes
#
#  index_doctrine_unlocks_on_doctrine_id                (doctrine_id)
#  index_doctrine_unlocks_on_doctrine_id_and_unlock_id  (doctrine_id,unlock_id) UNIQUE
#  index_doctrine_unlocks_on_doctrine_tree              (doctrine_id,tree,branch,row) UNIQUE
#  index_doctrine_unlocks_on_unlock_id                  (unlock_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctrine_id => doctrines.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#
require "rails_helper"

RSpec.describe DoctrineUnlock, type: :model do
  let!(:doctrine_unlock) { create :doctrine_unlock }

  describe 'associations' do
    it { should belong_to(:doctrine) }
    it { should belong_to(:unlock) }
    it { should have_one(:restriction) }
    it { should have_many(:restriction_units) }
    it { should have_many(:restriction_upgrades) }
    it { should have_many(:restriction_offmaps) }
  end
end
