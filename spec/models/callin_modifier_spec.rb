# == Schema Information
#
# Table name: callin_modifiers
#
#  id                                                                   :bigint           not null, primary key
#  description(Description)                                             :string
#  modifier(Modifies callin time)                                       :decimal(, )
#  modifier_type(Type of modification)                                  :string
#  priority(Priority in which the modifier is applied, from 1 -> 100)   :integer
#  unlock_name(Name of the unlock associated with this callin modifier) :string
#  created_at                                                           :datetime         not null
#  updated_at                                                           :datetime         not null
#
require "rails_helper"

RSpec.describe CallinModifier, type: :model do
  let!(:callin_modifier) { create :callin_modifier}

  describe 'associations' do
    it { should have_many(:restriction_callin_modifiers) }
    it { should have_many(:callin_modifier_required_units) }
    it { should have_many(:callin_modifier_allowed_units) }
  end

  describe 'validations' do
    it { should validate_presence_of(:modifier) }
    it { should validate_presence_of(:modifier_type) }
    it { should validate_presence_of(:priority) }
    it { should validate_numericality_of(:modifier) }
  end
end
