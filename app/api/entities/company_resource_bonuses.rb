module Entities
  class CompanyResourceBonuses < Grape::Entity
    expose :man_resource_bonus, using: ResourceBonus::Entity, as: :manResourceBonus
    expose :mun_resource_bonus, using: ResourceBonus::Entity, as: :munResourceBonus
    expose :fuel_resource_bonus, using: ResourceBonus::Entity, as: :fuelResourceBonus
    expose :man_bonus_count, as: :manBonusCount
    expose :mun_bonus_count, as: :munBonusCount
    expose :fuel_bonus_count, as: :fuelBonusCount
    expose :current_man, as: :currentMan
    expose :current_mun, as: :currentMun
    expose :current_fuel, as: :currentFuel
    expose :max_resource_bonuses, as: :maxResourceBonuses
  end
end
