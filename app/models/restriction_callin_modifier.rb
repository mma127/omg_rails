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
class RestrictionCallinModifier < ApplicationRecord
  belongs_to :restriction
  belongs_to :callin_modifier
  belongs_to :ruleset

  validates :restriction, presence: true
  validates :callin_modifier, presence: true
  validates :ruleset, presence: true

  before_save :generate_internal_description

  private

  def generate_internal_description
    self.internal_description = "#{restriction.description} | #{callin_modifier.description}"
  end
end

