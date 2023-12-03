csv_path = "db/seeds/elo_output_decay.csv"

hpr = []

CSV.foreach(csv_path, headers: true) do |row|
  name = row["name"]
  last_played = row["last_played"]
  elo = row["ts_elo"]
  mu = row["ts_mu"]
  sigma = row["ts_sigma"]

  hpr << HistoricalPlayerRating.new(player_name: name, last_played: last_played, elo: elo, mu: mu, sigma: sigma)
end

HistoricalPlayerRating.import! hpr
