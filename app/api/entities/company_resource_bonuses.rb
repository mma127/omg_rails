module Entities
  class CompanyResourceBonuses < Grape::Entity
    expose :resource_bonuses, using: ResourceBonus::Entity, as: :resourceBonuses
    expose :man_bonus_count, as: :manBonusCount
    expose :mun_bonus_count, as: :munBonusCount
    expose :fuel_bonus_count, as: :fuelBonusCount
    expose :current_man, as: :currentMan
    expose :current_mun, as: :currentMun
    expose :current_fuel, as: :currentFuel
    expose :max_resource_bonuses, as: :maxResourceBonuses
  end
end
