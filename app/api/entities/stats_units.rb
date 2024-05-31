module Entities
  module StatsUnits
    class WeaponCount < Grape::Entity
      expose :reference
      expose :count
    end

    class SlotItemCount < Grape::Entity
      expose :reference
      expose :weapon
      expose :count
    end

    class UpgradeWeapons < Grape::Entity
      expose :upgrade_id, as: :upgradeId
      expose :upgrade_const, as: :upgradeConst
      expose :upgrade_name, as: :upgradeName
      expose :weapon_count, as: :weaponCount, using: Entities::StatsUnits::WeaponCount
      expose :slot_item_count, as: :slotItemCount, using: Entities::StatsUnits::SlotItemCount
    end

    class StatsUnitResponse < Grape::Entity
      # Return a StatsUnit with associated StatsEntities and StatsWeapons
      expose :stats_unit, as: :statsUnit, using: StatsUnit::Entity
      expose :stats_entities, as: :statsEntities, using: StatsEntity::Entity

      expose :stats_weapons, as: :statsWeapons, using: StatsWeapon::Entity # This should be all weapons
      expose :default_weapons, as: :defaultWeapons, using: Entities::StatsUnits::WeaponCount
      expose :upgrade_weapons, as: :upgradeWeapons, using: Entities::StatsUnits::UpgradeWeapons

      expose :enabled_upgrades, as: :enabledUpgrades, using: RestrictionUpgrade::Entity
      expose :stats_upgrades, as: :statsUpgrades, using: StatsUpgrade::Entity
    end
  end
end
