# == Schema Information
#
# Table name: rulesets
#
#  id                                                               :bigint           not null, primary key
#  description(Description)                                         :string
#  max_resource_bonuses(Company maximum number of resource bonuses) :integer          not null
#  max_vps(Company max vps)                                         :integer          not null
#  name(Ruleset name)                                               :string           not null
#  starting_fuel(Company starting fuel)                             :integer          not null
#  starting_man(Company starting manpower)                          :integer          not null
#  starting_mun(Company starting muntions)                          :integer          not null
#  starting_vps(Company starting vps)                               :integer          not null
#  created_at                                                       :datetime         not null
#  updated_at                                                       :datetime         not null
#
class Ruleset < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :starting_man
  validates_presence_of :starting_mun
  validates_presence_of :starting_fuel
  validates_presence_of :starting_vps
  validates_presence_of :max_vps
  validates_presence_of :max_resource_bonuses

  validates_numericality_of :starting_man
  validates_numericality_of :starting_mun
  validates_numericality_of :starting_fuel
  validates_numericality_of :starting_vps
  validates_numericality_of :max_vps
  validates_numericality_of :max_resource_bonuses
end
