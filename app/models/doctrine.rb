# == Schema Information
#
# Table name: doctrines
#
#  id                                                           :bigint           not null, primary key
#  const_name(Doctrine CONST name for battlefile)               :string           not null
#  display_name(Display name)                                   :string           not null
#  internal_name(Name for internal code use, may not be needed) :string           not null
#  name(Raw name)                                               :string           not null
#  created_at                                                   :datetime         not null
#  updated_at                                                   :datetime         not null
#  faction_id                                                   :bigint
#
# Indexes
#
#  index_doctrines_on_const_name  (const_name) UNIQUE
#  index_doctrines_on_faction_id  (faction_id)
#  index_doctrines_on_name        (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (faction_id => factions.id)
#
class Doctrine < ApplicationRecord
  include ActiveModel::Serializers::JSON

  belongs_to :faction, inverse_of: :doctrines
  has_many :doctrine_unlocks
  has_many :unlocks, through: :doctrine_unlocks
  has_one :restriction

  validates_presence_of :name
  validates_presence_of :const_name
  validates_presence_of :display_name
  validates_presence_of :faction
  validates_uniqueness_of :name
  validates_uniqueness_of :const_name

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :display_name, as: :displayName
    expose :faction_id, as: :factionId
  end
end
