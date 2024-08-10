task battlefile_gen: :environment do
  battle_id = 47
  bfs = BattlefileService.new(47)

  bfs.generate_files
end
