module Entities
  class StatsUnitResponse < Grape::Entity
    # Return a StatsUnit with associated StatsEntities and StatsWeapons
    expose :stats_unit, as: :statsUnit, using: StatsUnit::Entity
    expose :stats_entities, as: :statsEntities, using: StatsEntity::Entity
    expose :stats_weapons, as: :statsWeapons, using: StatsWeapon::Entity
    expose :stats_weapons_upgrades, as: :statsWeaponsUpgrades, using: StatsWeapon::Entity
  end
end
