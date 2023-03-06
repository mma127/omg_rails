# == Schema Information
#
# Table name: upgrades
#
#  id                                                                                 :bigint           not null, primary key
#  additional_model_count(How many model entities this upgrade adds to the base unit) :integer
#  const_name(Upgrade const name used by the battlefile)                              :string
#  description(Upgrade description)                                                   :string
#  display_name(Display upgrade name)                                                 :string           not null
#  fuel(Fuel cost)                                                                    :integer
#  is_building(Is this upgrade a building to be built)                                :boolean
#  is_unit_replace(Does this upgrade replace units data)                              :boolean
#  man(Manpower cost)                                                                 :integer
#  model_count(How many model entities this unit replacement consists of)             :integer
#  mun(Munition cost)                                                                 :integer
#  name(Unique upgrade name)                                                          :string           not null
#  pop(Population cost)                                                               :integer
#  type(Type of Upgrade)                                                              :string           not null
#  unitwide_upgrade_slots(Upgrade slot cost for unit wide upgrades)                   :integer
#  upgrade_slots(Upgrade slot cost for per model upgrades)                            :integer
#  uses(Number of uses this upgrade provides)                                         :integer
#  created_at                                                                         :datetime         not null
#  updated_at                                                                         :datetime         not null
#
class Upgrade < ApplicationRecord

  # If this upgrade replaces a unit, use the model_count value to override the unit's model count
  with_options if: :unit_replace? do |unit_replace_upgrade|
    unit_replace_upgrade.validates :additional_model_count, presence: false
    unit_replace_upgrade.validates :model_count, presence: true
  end
  # If this upgrade is not a replacement, use the additional_model_count to add to the unit's model count
  with_options unless: :unit_replace? do |standard_upgrade|
    # standard_upgrade.validates :additional_model_count, presence: true # Not hard required (upgrade does not need to change model count)
    standard_upgrade.validates :model_count, presence: false
  end

  def unit_replace?
    is_unit_replace.present?
  end
end

