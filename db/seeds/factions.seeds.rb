after :rulesets do
  Seeds::FactionsService.update_or_create_all
end
