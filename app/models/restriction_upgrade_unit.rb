# == Schema Information
#
# Table name: restriction_upgrade_units
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  restriction_upgrade_id :bigint
#  unit_id                :bigint
#
# Indexes
#
#  index_restriction_upgrade_units_on_restriction_upgrade_id  (restriction_upgrade_id)
#  index_restriction_upgrade_units_on_unit_id                 (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (restriction_upgrade_id => restriction_upgrades.id)
#  fk_rails_...  (unit_id => units.id)
#
class RestrictionUpgradeUnit < ApplicationRecord
  belongs_to :restriction_upgrade, inverse_of: :restriction_upgrade_units
  belongs_to :unit

  validates :unit, uniqueness: { scope: :restriction_upgrade }

  def allowed?
    restriction_upgrade.type == EnabledUpgrade.name
  end
end
