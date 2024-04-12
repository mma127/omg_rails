class WarResetService < ApplicationService

  # IMPORTANT: Use this method to conduct a war reset.
  # This method orchestrates all required data seeding in order, particularly for data that requires a ruleset association
  def self.reset_ruleset(ruleset_type, name)
    new_ruleset = Seeds::RulesetSeeder.create_new_ruleset(ruleset_type, name)
    Seeds::FactionsSeeder.update_or_create_all # Also creates faction restrictions
    Seeds::DoctrinesSeeder.update_or_create_all # Also creates doctrine restrictions
    Seeds::UnitsSeeder.create_or_update_all # Also creates TransportAllowedUnits and UnitVet

    Seeds::ResourceBonusesSeeder.create_for_ruleset(new_ruleset)
    Seeds::UnlocksSeeder.create_for_ruleset(new_ruleset)
    Seeds::OffmapsSeeder.create_for_ruleset(new_ruleset)
    Seeds::CallinModifiersSeeder.create_for_ruleset(new_ruleset)

    Seeds::RestrictionUnitsSeeder.new(new_ruleset).create_for_ruleset
  end
end
