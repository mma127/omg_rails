module Entities
  class SquadsResponse < Grape::Entity
    expose :squads, using: Squad::Entity
    expose :available_units, using: AvailableUnit::Entity, as: :availableUnits
  end
end

