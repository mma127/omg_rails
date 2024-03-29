module Entities
  class SquadsResponse < Grape::Entity
    expose :squads, using: Squad::Entity
    expose :available_units, using: AvailableUnit::Entity, as: :availableUnits
    expose :company_offmaps, using: CompanyOffmap::Entity, as: :companyOffmaps
    expose :available_offmaps, using: AvailableOffmap::Entity, as: :availableOffmaps
    expose :callin_modifiers, using: CallinModifier::Entity, as: :callinModifiers
    expose :squad_upgrades, using: SquadUpgrade::Entity, as: :squadUpgrades
    expose :available_upgrades, using: AvailableUpgrade::Entity, as: :availableUpgrades
    expose :upgrades, using: Upgrade::Entity, as: :upgrades
    expose :company_resource_bonuses, with: Entities::CompanyResourceBonuses, as: :companyResourceBonuses
  end
end

