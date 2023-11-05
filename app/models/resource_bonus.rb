# == Schema Information
#
# Table name: resource_bonuses
#
#  id                        :bigint           not null, primary key
#  fuel_lost(Fuel deducted)  :integer          default(0), not null
#  gained(Bonus amount)      :integer          default(0), not null
#  man_lost(Man deducted)    :integer          default(0), not null
#  mun_lost(Mun deducted)    :integer          default(0), not null
#  name(Resource bonus name) :string           not null
#  resource(Resource type)   :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_resource_bonuses_on_resource  (resource) UNIQUE
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

  class Entity < Grape::Entity
    expose :name
    expose :resource
    expose :gained
    expose :man_lost, as: :manLost
    expose :mun_lost, as: :munLost
    expose :fuel_lost, as: :fuelLost
  end
end
