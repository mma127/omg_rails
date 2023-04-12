# == Schema Information
#
# Table name: restriction_callin_modifiers
#
#  id                                                                 :bigint           not null, primary key
#  internal_description(What does this RestrictionCallinModifier do?) :string           not null
#  type(What effect this restriction has on the callin modifier)      :string           not null
#  created_at                                                         :datetime         not null
#  updated_at                                                         :datetime         not null
#  callin_modifier_id                                                 :bigint
#  restriction_id                                                     :bigint
#  ruleset_id                                                         :bigint
#
# Indexes
#
#  index_restriction_callin_modifiers_on_callin_modifier_id  (callin_modifier_id)
#  index_restriction_callin_modifiers_on_restriction_id      (restriction_id)
#  index_restriction_callin_modifiers_on_ruleset_id          (ruleset_id)
#
# Foreign Keys
#
#  fk_rails_...  (callin_modifier_id => callin_modifiers.id)
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (ruleset_id => rulesets.id)
#
require "rails_helper"

RSpec.describe EnabledCallinModifier, type: :model do
  let!(:enabled_callin_modifier) { create :enabled_callin_modifier}

  describe 'associations' do
    it { should belong_to(:restriction) }
    it { should belong_to(:callin_modifier) }
    it { should belong_to(:ruleset) }
  end

  describe 'validations' do
    it { should validate_presence_of(:restriction) }
    it { should validate_presence_of(:callin_modifier) }
    it { should validate_presence_of(:ruleset) }
  end
end
