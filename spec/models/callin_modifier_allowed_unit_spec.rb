# == Schema Information
#
# Table name: callin_modifier_allowed_units
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  callin_modifier_id :bigint
#  unit_id            :bigint
#
# Indexes
#
#  index_callin_modifier_allowed_units_on_callin_modifier_id  (callin_modifier_id)
#  index_callin_modifier_allowed_units_on_unit_id             (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (callin_modifier_id => callin_modifiers.id)
#  fk_rails_...  (unit_id => units.id)
#
require "rails_helper"

RSpec.describe CallinModifierAllowedUnit, type: :model do
  let!(:callin_modifier_allowed_unit) { create :callin_modifier_allowed_unit}

  describe 'associations' do
    it { should belong_to(:callin_modifier) }
    it { should belong_to(:unit) }
  end

  describe 'validations' do
    it { should validate_presence_of(:callin_modifier) }
    it { should validate_presence_of(:unit) }
  end
end
