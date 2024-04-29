task load_stats: :environment do
  ruleset = Ruleset.where(is_active: true, ruleset_type: Ruleset.ruleset_types[:war]).last
  Seeds::SgaStatsSeeder.new(ruleset).create_for_ruleset
end
