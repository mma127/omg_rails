task reset_war: :environment do
  WarResetService.reset_ruleset(Ruleset.ruleset_types[:war], "May 2024")
end
