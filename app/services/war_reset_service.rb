class WarResetService < ApplicationService

  # IMPORTANT: Use this method to conduct a war reset.
  # This method orchestrates all required data seeding in order, particularly for data that requires a ruleset association
  def self.reset_ruleset(ruleset_type, name, upload_stats: false)
    ActiveRecord::Base.transaction do
      old_ruleset = Ruleset.find_by(ruleset_type: ruleset_type, is_active: true)
      delete_ruleset_specific_records(old_ruleset) if old_ruleset.present?

      new_ruleset = Seeds::RulesetSeeder.create_new_ruleset(ruleset_type, name)
      Seeds::FactionsSeeder.update_or_create_all # Also creates faction restrictions
      Seeds::DoctrinesSeeder.update_or_create_all # Also creates doctrine restrictions
      Seeds::UnitsSeeder.create_or_update_all # Also creates TransportAllowedUnits and UnitVet
      Seeds::UpgradesSeeder.create_or_update_all

      Seeds::ResourceBonusesSeeder.create_for_ruleset(new_ruleset)
      Seeds::UnlocksSeeder.create_for_ruleset(new_ruleset)
      Seeds::OffmapsSeeder.create_for_ruleset(new_ruleset)
      Seeds::CallinModifiersSeeder.create_for_ruleset(new_ruleset)

      Seeds::RestrictionUnitsSeeder.new(new_ruleset).create_for_ruleset # Also creates unit swaps
      Seeds::RestrictionUpgradesSeeder.new(new_ruleset).create_for_ruleset # Also creates upgrade swaps

      if upload_stats
        Seeds::SgaStatsSeeder.new(new_ruleset).create_for_ruleset
      end
    end
  end

  # Remove ruleset specific models that don't need to carry over
  def self.delete_ruleset_specific_records(old_ruleset)
    Company.where(ruleset_id: old_ruleset.id).destroy_all
    Battle.where(ruleset_id: old_ruleset.id).destroy_all
    ChatMessage.destroy_all
  end
end
