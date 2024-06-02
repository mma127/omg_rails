class StatsWeaponsService < ApplicationService
  def self.fetch_for_reference(reference, ruleset_id)
    StatsWeapon.find_by(ruleset_id: ruleset_id, reference: reference)
  end
end
