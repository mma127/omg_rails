# == Schema Information
#
# Table name: rulesets
#
#  id                                      :bigint           not null, primary key
#  description(Description)                :string
#  name(Ruleset name)                      :string           not null
#  starting_fuel(Company starting fuel)    :integer          not null
#  starting_man(Company starting manpower) :integer          not null
#  starting_mun(Company starting muntions) :integer          not null
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#
class Ruleset < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :starting_man
  validates_presence_of :starting_mun
  validates_presence_of :starting_fuel

  validates_numericality_of :starting_man
  validates_numericality_of :starting_mun
  validates_numericality_of :starting_fuel
end
