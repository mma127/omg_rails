module Entities
  class RestrictionUpgradesResult < Grape::Entity
    expose :upgrade_id, as: :upgradeId
    expose :unit_names, as: :unitNames
    expose :active_restriction_upgrade, as: :activeRestrictionUpgrade, using: RestrictionUpgrade::Entity
    expose :overridden_restriction_upgrades, as: :overriddenRestrictionUpgrades, using: RestrictionUpgrade::Entity
    expose :restriction_upgrade_id_path_key, as: :restrictionUpgradeIdPathKey
  end
end
