require 'csv'
require 'saulabs/trueskill'
# require 'TrueSkill'

include Saulabs::TrueSkill

task generate_elo_csv: :environment do
  ALLIES = "Allies".freeze
  AXIS = "Axis".freeze

  DOC_TO_SIDE = {
    "ALLY": ALLIES,
    "CMW": ALLIES,
    "AXIS": AXIS,
    "PE": AXIS
  }.with_indifferent_access

  MU = 25.0
  SIGMA = 25.0 / 3.0
  DRAW_PROBABILITY = 0.0

  WEEKLY_DECAY = 0.05

  @players_by_name = {}.with_indifferent_access

  def get_side_from_doctrine(doctrine)
    const = doctrine.split(".").second
    DOC_TO_SIDE[const]
  end

  def parse_date(raw_date)
    Date::strptime(raw_date, "%d/%m/%y")
  end

  # Parse the row to get match id and a MatchPlayer object for the player
  def handle_csv_row(row)
    # Find player if exists
    name = row["Player"]

    # If exists, grab Player model
    if @players_by_name.has_key? name
      player = @players_by_name[name]
    else
      # Create a new Player model for this name
      ts_rating = Rating.new(MU, SIGMA)
      player = Ratings::Player.new(name, ts_rating)
      @players_by_name[name] = player
    end

    side = get_side_from_doctrine(row["Doctrine"])
    match_player = Ratings::MatchPlayer.new(name, side, player.ts_rating, player.last_played)

    [row["Game-ID"], parse_date(row["Date"]), row["Winner"], match_player]
  end

  def update_sigma_decay(ts_rating, weeks_since_last_played)
    # within 3 weeks, no decay
    if weeks_since_last_played > 3
      weeks_since_last_played -= 3

      sigma_decay = WEEKLY_DECAY * weeks_since_last_played
      ts_rating = Rating.new(ts_rating.mean, [SIGMA, ts_rating.deviation + sigma_decay].min)
    end
    ts_rating
  end

  # Run rating update for the players in the match
  def process_match(match)
    match_date = match.date

    # For each player, get last played date
    # Calculate sigma decay if necessary and update rating
    match_players = match.allies_players + match.axis_players
    match_players.each do |match_player|
      weeks_since_last_played = match_player.weeks_since_last_played(match_date)
      ts_rating = update_sigma_decay(match_player.ts_rating, weeks_since_last_played)
      match_player.ts_rating = ts_rating
    end

    # Build lists of team ratings
    # Rate the match using the model (first team is the winner)
    allies_ts_ratings = match.allies_players.map{ |p| p.ts_rating}
    axis_ts_ratings = match.axis_players.map{ |p| p.ts_rating}

    if match.allied_win?
      ts_teams = [allies_ts_ratings, axis_ts_ratings]
    else
      ts_teams = [axis_ts_ratings, allies_ts_ratings]
    end
    FactorGraph.new(ts_teams, [1,2]).update_skills

    match_players.each do |mp|
      player = @players_by_name[mp.name]
      player.update_ts_rating(mp.ts_rating, match_date)
      player.update_win_loss(mp.side == match.winner)
    end
  end

  def get_min_max_mu(players)
    ts_min = 100
    ts_max = 0
    players.each do |player|
      ts_mu = player.ts_rating.mean
      ts_min = [ts_mu, ts_min].min
      ts_max = [ts_mu, ts_max].max
    end

    return [ts_min, ts_max]
  end

  def normalize_to_elo(mu, old_min, old_max)
    new_min = 1000
    new_max = 2000
    return ((mu - old_min) / (old_max - old_min)) * (new_max - new_min) + new_min
  end

  def parse_csv(filename)
    matches = 0
    current_match = nil
    CSV.foreach(filename, headers: true) do |row|
      match_id, match_date, match_winner, match_player = handle_csv_row(row)

      # For first match in the dataset, current_match_id is nil, skip
      # Otherwise, if current_match_id is different from match_id, we know we've reached a new match,
      # and we should process the current match players
      if current_match.present? && match_id != current_match.match_id
        process_match(current_match)
        matches += 1
      end

      # Set the first match or reset the current match id and players
      if current_match.blank? || match_id != current_match.match_id
        current_match = Ratings::Match.new(match_id, match_winner, match_date)
      end

      current_match.add_player(match_player)
    end

    # At the end of iteration, process the final match
    if current_match.allies_players.size == current_match.axis_players.size
      process_match(current_match)
    end

    ts_min, ts_max = get_min_max_mu(@players_by_name.values)

    CSV.open("elo_output_decay.csv", "w") do |csv|
      csv << ["name", "games played", "wins", "losses", "last_played", "ts_elo", "ts_mu", "ts_sigma"]

      keys = @players_by_name.keys.sort
      keys.each do |key|
        player = @players_by_name[key]
        ts_elo = normalize_to_elo(player.ts_rating.mean, ts_min, ts_max)
        csv << [player.name, player.games_played, player.wins, player.losses, player.last_played,
                ts_elo, player.ts_rating.mean, player.ts_rating.deviation]
      end
    end
  end

  parse_csv("lib/tasks/elo_dataset.csv")
end
