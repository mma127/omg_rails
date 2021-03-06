# == Schema Information
#
# Table name: units
#
#  id                                                        :bigint           not null, primary key
#  const_name(Const name of the unit for the battle file)    :string           not null
#  description(Display description of the unit)              :text
#  display_name(Display name)                                :string           not null
#  is_airdrop(Is this unit airdroppable?)                    :boolean          default(FALSE), not null
#  is_infiltrate(Is this unit able to infiltrate?)           :boolean          default(FALSE), not null
#  name(Unique unit name)                                    :string           not null
#  retreat_name(Name for retreating unit)                    :string
#  type(Unit type)                                           :string           not null
#  unitwide_upgrade_slots(Unit wide weapon replacement slot) :integer          default(0), not null
#  upgrade_slots(Slots used for per model weapon upgrades)   :integer          default(0), not null
#  created_at                                                :datetime         not null
#  updated_at                                                :datetime         not null
#
# Indexes
#
#  index_units_on_name  (name)
#
require "rails_helper"

RSpec.describe Unit, type: :model do
  let!(:unit) { create :unit}

  describe 'associations' do
    it { should have_many(:unit_modifications) }
    it { should have_many(:unit_games) }
    it { should have_many(:games) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:const_name) }
    it { should validate_presence_of(:display_name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_numericality_of(:unitwide_upgrade_slots) }
    it { should validate_numericality_of(:upgrade_slots) }
  end
end

