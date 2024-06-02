# == Schema Information
#
# Table name: resource_bonuses
#
#  id                        :bigint           not null, primary key
#  fuel(Fuel change)         :integer          default(0), not null
#  man(Man change)           :integer          default(0), not null
#  mun(Mun change)           :integer          default(0), not null
#  name(Resource bonus name) :string           not null
#  resource(Resource type)   :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  ruleset_id                :bigint           not null
#
# Indexes
#
#  index_resource_bonuses_on_resource_and_ruleset_id  (resource,ruleset_id) UNIQUE
#  index_resource_bonuses_on_ruleset_id               (ruleset_id)
#
# Foreign Keys
#
#  fk_rails_...  (ruleset_id => rulesets.id)
#
class ResourceBonus < ApplicationRecord
  belongs_to :ruleset
  has_many :company_resource_bonuses

  enum resource: {
    man: "man",
    mun: "mun",
    fuel: "fuel"
  }

  validates_presence_of :name
  validates_presence_of :resource
  validates_presence_of :man
  validates_presence_of :mun
  validates_presence_of :fuel
  validates_numericality_of :man
  validates_numericality_of :mun
  validates_numericality_of :fuel

  class Entity < Grape::Entity
    expose :name
    expose :resource
    expose :man
    expose :mun
    expose :fuel
  end
end
