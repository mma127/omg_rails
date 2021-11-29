# == Schema Information
#
# Table name: upgrades
#
#  id                                                               :bigint           not null, primary key
#  const_name(Upgrade const name used by the battlefile)            :string
#  fuel(Fuel cost)                                                  :integer
#  is_building(Is this upgrade a building to be built)              :boolean
#  is_unit_replace(Does this upgrade replace units data)            :boolean
#  man(Manpower cost)                                               :integer
#  mun(Munition cost)                                               :integer
#  pop(Population cost)                                             :integer
#  unitwide_upgrade_slots(Upgrade slot cost for unit wide upgrades) :integer
#  upgrade_slots(Upgrade slot cost for per model upgrades)          :integer
#  uses(Number of uses this upgrade provides)                       :integer
#  created_at                                                       :datetime         not null
#  updated_at                                                       :datetime         not null
#  restriction_id                                                   :bigint
#
# Indexes
#
#  index_upgrades_on_restriction_id  (restriction_id)
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#
class Upgrade < ApplicationRecord

  belongs_to :restriction

  has_many :upgrade_modifications
end

