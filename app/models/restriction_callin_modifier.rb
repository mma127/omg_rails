# == Schema Information
#
# Table name: restriction_callin_modifiers
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  callin_modifier_id :bigint
#  restriction_id     :bigint
#
# Indexes
#
#  index_restriction_callin_modifiers_on_callin_modifier_id  (callin_modifier_id)
#  index_restriction_callin_modifiers_on_restriction_id      (restriction_id)
#
# Foreign Keys
#
#  fk_rails_...  (callin_modifier_id => callin_modifiers.id)
#  fk_rails_...  (restriction_id => restrictions.id)
#
class RestrictionCallinModifier < ApplicationRecord
  belongs_to :restriction
  belongs_to :callin_modifier
end

