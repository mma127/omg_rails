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
  CONST_PREFIX = "OMGUPG"

  validates :model_count, presence: false

  # Used for battle file
  def formatted_const_name
    "#{CONST_PREFIX}.#{const_name}"
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :display_name, as: :displayName
    expose :description
    expose :type
    expose :model_count, as: :modelCount
    expose :additional_model_count, as: :additionalModelCount
  end
end

