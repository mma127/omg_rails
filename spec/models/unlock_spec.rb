# == Schema Information
#
# Table name: unlocks
#
#  id                                                                 :bigint           not null, primary key
#  const_name(Const name of the doctrine ability for the battle file) :string
#  description(Display description of this doctrine ability)          :text
#  display_name(Unlock display name)                                  :string           not null
#  image_path(Url to the image to show for this doctrine ability)     :string
#  name(Unlock internal name)                                         :string           not null
#  created_at                                                         :datetime         not null
#  updated_at                                                         :datetime         not null
#
# Indexes
#
#  index_unlocks_on_name  (name) UNIQUE
#
require "rails_helper"

RSpec.describe Unlock, type: :model do
  let!(:unit_swap) { create :unit_swap}

  describe 'associations' do
    it { should have_many(:doctrine_unlocks) }
    it { should have_many(:doctrines) }
    it { should have_one(:restriction) }
    it { should have_many(:restriction_units) }
    it { should have_many(:restriction_upgrades) }
    it { should have_many(:restriction_offmaps) }
  end
end
