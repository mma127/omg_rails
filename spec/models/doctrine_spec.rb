# == Schema Information
#
# Table name: doctrines
#
#  id                                                           :bigint           not null, primary key
#  const_name(Doctrine CONST name for battlefile)               :string           not null
#  display_name(Display name)                                   :string           not null
#  internal_name(Name for internal code use, may not be needed) :string           not null
#  name(Raw name)                                               :string           not null
#  created_at                                                   :datetime         not null
#  updated_at                                                   :datetime         not null
#  faction_id                                                   :bigint
#
# Indexes
#
#  index_doctrines_on_const_name  (const_name) UNIQUE
#  index_doctrines_on_faction_id  (faction_id)
#  index_doctrines_on_name        (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (faction_id => factions.id)
#
require "rails_helper"

RSpec.describe Doctrine, type: :model do
  let!(:doctrine) { create :doctrine}

  describe 'associations' do
    it { should belong_to(:faction) }
    it { should have_many(:doctrine_unlocks) }
    it { should have_many(:unlocks) }
    it { should have_many(:restrictions) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:const_name) }
    it { should validate_presence_of(:display_name) }
    it { should validate_presence_of(:faction) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:const_name) }
  end
end

