task update_offmaps_values: :environment do
  ruleset = Ruleset.where(is_active: true, ruleset_type: Ruleset.ruleset_types[:war]).last
  Seeds::OffmapsSeeder.update_offmap_values_for_ruleset(ruleset)
end
