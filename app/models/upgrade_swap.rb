# == Schema Information
#
# Table name: upgrade_swaps
#
#  id                                                             :bigint           not null, primary key
#  internal_description(Internal description of this UpgradeSwap) :string
#  created_at                                                     :datetime         not null
#  updated_at                                                     :datetime         not null
#  new_upgrade_id                                                 :bigint           not null
#  old_upgrade_id                                                 :bigint           not null
#  unlock_id                                                      :bigint           not null
#
# Indexes
#
#  index_upgrade_swaps_on_new_upgrade_id                (new_upgrade_id)
#  index_upgrade_swaps_on_old_upgrade_id                (old_upgrade_id)
#  index_upgrade_swaps_on_unlock_id                     (unlock_id)
#  index_upgrade_swaps_on_unlock_id_and_new_upgrade_id  (unlock_id,new_upgrade_id) UNIQUE
#  index_upgrade_swaps_on_unlock_id_and_old_upgrade_id  (unlock_id,old_upgrade_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (new_upgrade_id => upgrades.id)
#  fk_rails_...  (old_upgrade_id => upgrades.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#
class UpgradeSwap < ApplicationRecord
  belongs_to :unlock
  belongs_to :old_upgrade, class_name: "Upgrade"
  belongs_to :new_upgrade, class_name: "Upgrade"

  before_save :generate_internal_description

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :unlock_id
    # expose :old_upgrade, as: :oldUpgrade, using: Upgrade::Entity
    # expose :new_upgrade, as: :newUpgrade, using: Upgrade::Entity
  end

  private

  def generate_internal_description
    self.internal_description = "#{unlock.display_name} | #{old_upgrade.display_name} -> #{new_upgrade.display_name}"
  end
end
