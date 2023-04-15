module Entities
  class SquadsResponse < Grape::Entity
    expose :squads, using: Squad::Entity
    expose :available_units, using: AvailableUnit::Entity, as: :availableUnits
    expose :company_offmaps, using: CompanyOffmap::Entity, as: :companyOffmaps
    expose :available_offmaps, using: AvailableOffmap::Entity, as: :availableOffmaps
    expose :callin_modifiers, using: CallinModifier::Entity, as: :callinModifiers
  end
end

