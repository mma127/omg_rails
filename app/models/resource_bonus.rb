# == Schema Information
#
# Table name: resource_bonuses
#
#  id                        :bigint           not null, primary key
#  name(Resource bonus name) :string
#  type(Resource type)       :string
#  value(Bonus amount)       :integer
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
end
