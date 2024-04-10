after :factions do
  Seeds::DoctrinesService.update_or_create_all
end
