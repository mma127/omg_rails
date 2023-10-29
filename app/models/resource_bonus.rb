# == Schema Information
#
# Table name: resource_bonuses
#
#  id                        :bigint           not null, primary key
#  fuel_lost(Fuel deducted)  :integer          default(0)
#  gained(Bonus amount)      :integer          default(0)
#  man_lost(Man deducted)    :integer          default(0)
#  mun_lost(Mun deducted)    :integer          default(0)
#  name(Resource bonus name) :string
#  resource(Resource type)   :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class ResourceBonus < ApplicationRecord
  has_many :company_resource_bonuses

  enum resource: {
    man: "man",
    mun: "mun",
    fuel: "fuel"
  }

  validates_presence_of :name
  validates_presence_of :resource
  validates_presence_of :gained
  validates_presence_of :man_lost
  validates_presence_of :mun_lost
  validates_presence_of :fuel_lost
  validates_numericality_of :gained
  validates_numericality_of :man_lost
  validates_numericality_of :mun_lost
  validates_numericality_of :fuel_lost
end
