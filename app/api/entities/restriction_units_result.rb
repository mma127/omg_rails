module Entities
  class RestrictionUnitsResult < Grape::Entity
    expose :unit_id, as: :unitId
    expose :active_restriction_unit, as: :activeRestrictionUnit, using: RestrictionUnit::Entity
    expose :overridden_restriction_units, as: :overriddenRestrictionUnits, using: RestrictionUnit::Entity
  end
end
