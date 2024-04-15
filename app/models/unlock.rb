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
#  ruleset_id                                                         :bigint           not null
#
# Indexes
#
#  index_unlocks_on_name_and_ruleset_id  (name,ruleset_id) UNIQUE
#  index_unlocks_on_ruleset_id           (ruleset_id)
#
# Foreign Keys
#
#  fk_rails_...  (ruleset_id => rulesets.id)
#
class Unlock < ApplicationRecord
  belongs_to :ruleset

  has_many :doctrine_unlocks
  has_many :doctrines, through: :doctrine_unlocks
  has_one :restriction

  has_many :unit_swaps, inverse_of: :unlock
  has_many :restriction_units, through: :restriction
  has_many :restriction_upgrades, through: :restriction
  has_many :restriction_offmaps, through: :restriction

  validates :name, presence: true, uniqueness: { scope: :ruleset_id }
  validates :display_name, presence: true

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :display_name, as: :displayName
    expose :const_name, as: :constName
    expose :description
    expose :image_path, as: :imagePath
  end
end
