# == Schema Information
#
# Table name: rulesets
#
#  id                                                               :bigint           not null, primary key
#  description(Description)                                         :string
#  is_active(Is this ruleset active for its ruleset type?)          :boolean          not null
#  max_resource_bonuses(Company maximum number of resource bonuses) :integer          not null
#  max_vps(Company max vps)                                         :integer          not null
#  name(Ruleset name)                                               :string           not null
#  ruleset_type(Type of ruleset this is)                            :string           not null
#  starting_fuel(Company starting fuel)                             :integer          not null
#  starting_man(Company starting manpower)                          :integer          not null
#  starting_mun(Company starting muntions)                          :integer          not null
#  starting_vps(Company starting vps)                               :integer          not null
#  created_at                                                       :datetime         not null
#  updated_at                                                       :datetime         not null
#
# Indexes
#
#  index_rulesets_on_ruleset_type_and_is_active  (ruleset_type,is_active)
#
class Ruleset < ApplicationRecord
  has_many :unlocks, inverse_of: :ruleset
  has_many :doctrine_unlocks, inverse_of: :ruleset
  has_many :offmaps, inverse_of: :ruleset
  has_many :restriction_units, inverse_of: :ruleset
  has_many :restriction_upgrades, inverse_of: :ruleset
  has_many :restriction_offmaps, inverse_of: :ruleset
  has_many :restriction_callin_modifiers, inverse_of: :ruleset
  has_many :resource_bonuses, inverse_of: :ruleset
  has_many :companies, inverse_of: :ruleset

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

  validates_uniqueness_of :is_active, scope: :ruleset_type, if: :is_active

  enum ruleset_type: {
    war: "war"
  }
end
