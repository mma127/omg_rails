# == Schema Information
#
# Table name: restriction_units
#
#  id                                                 :bigint           not null, primary key
#  type(What effect this restriction has on the unit) :string           not null
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  restriction_id                                     :bigint
#  unit_id                                            :bigint
#
# Indexes
#
#  index_restriction_units_on_restriction_id  (restriction_id)
#  index_restriction_units_on_unit_id         (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (unit_id => units.id)
#
class RestrictionUnit < ApplicationRecord
  belongs_to :restriction
  belongs_to :unit

  enum types: {
    allow: "allow",
    disallow: "disallow"
  }
end
