# == Schema Information
#
# Table name: players
#
#  id                          :bigint           not null, primary key
#  avatar(Player avatar url)   :text
#  current_sign_in_at          :datetime
#  current_sign_in_ip          :string
#  jti                         :string           not null
#  last_sign_in_at             :datetime
#  last_sign_in_ip             :string
#  name(Player screen name)    :string
#  provider(Omniauth provider) :string
#  sign_in_count               :integer          default(0), not null
#  uid(Omniauth uid)           :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_players_on_jti  (jti) UNIQUE
#
class Player < ApplicationRecord
  include ActiveModel::Serializers::JSON
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :trackable, :timeoutable,:jwt_authenticatable, :omniauthable,
         jwt_revocation_strategy: self, omniauth_providers: %i[steam]
  self.skip_session_storage = [:http_auth, :params_auth, :omniauth]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |player|
      player.name = auth.info.nickname
      player.avatar = auth.info.image
    end
  end

  def jwt_payload
    super.merge('foo' => 'bar')
  end
end
