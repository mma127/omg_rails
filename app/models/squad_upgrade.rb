# == Schema Information
#
# Table name: squad_upgrades
#
#  id                                                                                        :bigint           not null, primary key
#  is_free(Flag for whether this upgrade is free for the squad and has no availability cost) :boolean
#  created_at                                                                                :datetime         not null
#  updated_at                                                                                :datetime         not null
#  available_upgrade_id                                                                      :bigint
#  squad_id                                                                                  :bigint
#
# Indexes
#
#  index_squad_upgrades_on_available_upgrade_id  (available_upgrade_id)
#  index_squad_upgrades_on_squad_id              (squad_id)
#
# Foreign Keys
#
#  fk_rails_...  (available_upgrade_id => available_upgrades.id)
#  fk_rails_...  (squad_id => squads.id)
#
class SquadUpgrade < ApplicationRecord
  belongs_to :squad, inverse_of: :squad_upgrades
  belongs_to :available_upgrade
  has_one :upgrade, through: :available_upgrade

  validates :squad, presence: true
  validates :available_upgrade, presence: true

  def squad_uuid
    squad.uuid
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :squad_id, as: :squadId
    expose :available_upgrade_id, as: :availableUpgradeId
    expose :squad_uuid, as: :squadUuid

    expose :upgrade, using: Upgrade::Entity, if: { type: :include_upgrade }
    expose :available_upgrade, using: AvailableUpgrade::Entity, as: :availableUpgrade, if: { type: :include_upgrade }
  end
end
