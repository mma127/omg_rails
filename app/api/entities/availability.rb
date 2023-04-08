module Entities
  class Availability < Grape::Entity
    expose :available_units, using: AvailableUnit::Entity, as: :availableUnits
    expose :available_offmaps, using: AvailableOffmap::Entity, as: :availableOffmaps
  end
end

