# == Schema Information
#
# Table name: unlocks
#
#  id                                                                 :bigint           not null, primary key
#  const_name(Const name of the doctrine ability for the battle file) :string
#  description(Display description of this doctrine ability)          :text
#  display_name(Unlock display name)                                  :string           not null
#  image_path(Url to the image to show for this doctrine ability)     :string
#  name(Unlock internal name)                                         :string           not null
#  created_at                                                         :datetime         not null
#  updated_at                                                         :datetime         not null
#
# Indexes
#
#  index_unlocks_on_name  (name) UNIQUE
#
class Unlock < ApplicationRecord
  has_many :doctrine_unlocks
  has_many :doctrines, through: :doctrine_unlocks
  has_one :restriction

  has_many :restriction_units, through: :restriction
  has_many :restriction_upgrades, through: :restriction
  has_many :restriction_offmaps, through: :restriction

  validates_presence_of :name
  validates_presence_of :display_name
  validates_uniqueness_of :name

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :display_name, as: :displayName
    expose :description
    expose :image_path, as: :imagePath
  end
end
