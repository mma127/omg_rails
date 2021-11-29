# == Schema Information
#
# Table name: upgrade_modifications
#
#  id                                                                               :bigint           not null, primary key
#  const_name(Replacement upgrade name used by the battle file)                     :string
#  fuel(Modified fuel cost)                                                         :integer
#  is_building(Replacement flag for whether this upgrade is a building to be built) :boolean
#  is_unit_replace(Replacement flag for whether this upgrade replaces units data)   :boolean
#  man(Modified manpower cost)                                                      :integer
#  mun(Modified munition cost)                                                      :integer
#  pop(Modified population cost)                                                    :integer
#  priority(Priority order to apply the modification from 1 -> 100)                 :integer
#  type(Type of modification)                                                       :string
#  unitwide_upgrade_slots(Modified upgrade slot cost for unit wide upgrades)        :integer
#  upgrade_slots(Modified upgrade slot cost for per model upgrades)                 :integer
#  uses(Modified number of upgrade uses)                                            :integer
#  created_at                                                                       :datetime         not null
#  updated_at                                                                       :datetime         not null
#  restriction_id                                                                   :bigint
#  unlock_id                                                                        :bigint
#  upgrade_id                                                                       :bigint
#
# Indexes
#
#  index_upgrade_modifications_on_restriction_id  (restriction_id)
#  index_upgrade_modifications_on_unlock_id       (unlock_id)
#  index_upgrade_modifications_on_upgrade_id      (upgrade_id)
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#  fk_rails_...  (upgrade_id => upgrades.id)
#
class UpgradeModification < ApplicationRecord
  belongs_to :upgrade
  belongs_to :unlock
  belongs_to :restriction
end
