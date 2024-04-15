# == Schema Information
#
# Table name: upgrades
#
#  id                                                                                 :bigint           not null, primary key
#  additional_model_count(How many model entities this upgrade adds to the base unit) :integer
#  const_name(Upgrade const name used by the battlefile)                              :string
#  description(Upgrade description)                                                   :string
#  display_name(Display upgrade name)                                                 :string           not null
#  model_count(How many model entities this unit replacement consists of)             :integer
#  name(Unique upgrade name)                                                          :string           not null
#  type(Type of Upgrade)                                                              :string           not null
#  created_at                                                                         :datetime         not null
#  updated_at                                                                         :datetime         not null
#
# Indexes
#
#  index_upgrades_on_name  (name) UNIQUE
#
class Upgrade < ApplicationRecord
  CONST_PREFIX = "OMGUPG"

  has_many :available_upgrades, inverse_of: :upgrade

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

