# == Schema Information
#
# Table name: players
#
#  id                          :bigint           not null, primary key
#  avatar(Player avatar url)   :text
#  current_sign_in_at          :datetime
#  current_sign_in_ip          :string
#  last_sign_in_at             :datetime
#  last_sign_in_ip             :string
#  name(Player screen name)    :string
#  provider(Omniauth provider) :string
#  sign_in_count               :integer          default(0), not null
#  uid(Omniauth uid)           :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
class Player < ApplicationRecord
  include ActiveModel::Serializers::JSON
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :trackable, :timeoutable, :omniauthable, omniauth_providers: %i[steam]

  def self.from_omniauth(auth)
    player = where(provider: auth.provider, uid: auth.uid).first_or_create!
    player.name = auth.info.nickname
    player.avatar = auth.info.image
    player.save!
    player
  end

  has_many :companies
  has_many :doctrines, through: :companies
  has_many :factions, through: :companies

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :avatar
  end
end
