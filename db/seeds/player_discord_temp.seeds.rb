csv_path = "db/seeds/player_discord_ids.csv"

pdt = []
CSV.foreach(csv_path, headers: true) do |row|
  name = row["profile"]
  discord_id = row["discord_id"]
  pdt << PlayerDiscordTemp.new(player_name: name, discord_id: discord_id)
end

PlayerDiscordTemp.import! pdt
