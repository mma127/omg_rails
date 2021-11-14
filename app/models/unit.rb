# == Schema Information
#
# Table name: units
#
#  id                                                                                    :bigint           not null, primary key
#  company_max(Maximum number of the unit a company can hold)                            :integer
#  const_name(Const name of the unit for the battle file)                                :string
#  description(Display description of the unit)                                          :text
#  display_name(Display name)                                                            :string
#  fuel(Fuel cost)                                                                       :integer
#  is_airdrop(Is this unit airdroppable?)                                                :boolean
#  is_infiltrate(Is this unit able to infiltrate?)                                       :boolean
#  man(Manpower cost)                                                                    :integer
#  mun(Munition cost)                                                                    :integer
#  pop(Population cost)                                                                  :integer
#  resupply(Per game resupply)                                                           :integer
#  resupply_max(How much resupply is available from saved up resupplies, <= company max) :integer
#  retreat_name(Name for retreating unit)                                                :string
#  unitwide_upgrade_slots(Unit wide weapon replacement slot)                             :integer
#  upgrade_slots(Slots used for per model weapon upgrades)                               :integer
#  created_at                                                                            :datetime         not null
#  updated_at                                                                            :datetime         not null
#
class Unit < ApplicationRecord

  has_many :unit_modifications
end
