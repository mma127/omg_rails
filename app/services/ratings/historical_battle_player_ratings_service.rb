require 'saulabs/trueskill'

include Saulabs::TrueSkill

module Ratings
  class HistoricalBattlePlayerRatingsService < ApplicationService
    ALLIES = "Allies".freeze
    AXIS = "Axis".freeze

    FACTION_SIDE_TO_SIDE = {
      Faction.sides[:allied] => ALLIES,
      Faction.sides[:axis] => AXIS,
    }.with_indifferent_access

    MU = 25.0
    SIGMA = 25.0 / 3.0
    DRAW_PROBABILITY = 0.0

    def initialize
      @player_id_to_name = {}
      @player_name_to_player = {}
      @player_id_to_player = {}
      @player_id_to_player_rating = {}
      @player_id_to_temp_rating = {}
      @hpr_by_name = ::HistoricalPlayerRating.all.index_by(&:player_name)

      @ratings_player_by_player_id = {}
    end

    # Assumes HistoricalPlayerRatings is ready to use
    # For each HistoricalBattlePlayer, in order asc
    # Associate HistoricalPlayerRating by player name to HBP player name, index by player id
    def recalculate_player_ratings_from_historical
      matches = 0
      current_match = nil
      ::HistoricalBattlePlayer.includes(:faction, :doctrine).order(:id).find_each do |hbp|
        populate_player_data_if_missing(hbp)
        puts "player #{hbp.player_name}"
        match_id = hbp.battle_id
        date = hbp.created_at
        winner = if hbp.is_winner?
                   hbp.side == Faction.sides[:allied] ? ALLIES : AXIS
                 else
                   hbp.side == Faction.sides[:allied] ? AXIS : ALLIES
                 end
        temp_rating = @player_id_to_temp_rating[hbp.player_id]
        match_player = Ratings::MatchPlayer.new(hbp.player_name, FACTION_SIDE_TO_SIDE[hbp.side], temp_rating, nil, hbp.player_id)

        # For first match in the dataset, current_match_id is nil, skip
        # Otherwise, if current_match_id is different from match_id, we know we've reached a new match,
        # and we should process the current match players
        if current_match.present? && match_id != current_match.match_id
          process_match(current_match)
          matches += 1
        end

        # Set the first match or reset the current match id and players
        if current_match.blank? || match_id != current_match.match_id
          current_match = Ratings::Match.new(match_id, winner, date)
        end

        current_match.add_player(match_player)
      end

      # At the end of iteration, process the final match
      if current_match.allies_players.size == current_match.axis_players.size
        process_match(current_match)
      end

      ts_min, ts_max = get_min_max_mu(@ratings_player_by_player_id.values)

      CSV.open("recalc_elo_output.csv", "w") do |csv|
        csv << %w[name player_id old_elo old_mu old_sigma recalc_elo recalc_mu recalc_sigma]

        keys = @ratings_player_by_player_id.keys.sort
        keys.each do |key|
          player = @ratings_player_by_player_id[key]
          old_player_rating = @player_id_to_player_rating[key]
          ts_elo = normalize_to_elo(player.ts_rating.mean, ts_min, ts_max)
          csv << [player.name, key, old_player_rating.elo, old_player_rating.mu, old_player_rating.sigma,
                  ts_elo, player.ts_rating.mean, player.ts_rating.deviation]
        end
      end

    end

    private

    def populate_player_data_if_missing(hbp)
      return if @player_id_to_name.include? hbp.player_id

      # Set by the first name seen for the id
      # NOTE: Assume this is the historical player name
      @player_id_to_name[hbp.player_id] = hbp.player_name

      # HBP must have a Player created for it, currently no way of deleting players
      player = ::Player.includes(:player_rating).find_by!(id: hbp.player_id)
      @player_id_to_player[hbp.player_id] = player
      @player_id_to_player_rating[hbp.player_id] = player.player_rating
      @player_name_to_player[hbp.player_name] = player

      if @hpr_by_name.include? hbp.player_name.upcase
        hpr = @hpr_by_name[hbp.player_name.upcase]
        hpr.update!(player_id: player.id)
        temp_rating = Ratings::NamedRating.new(hbp.player_name, hpr.mu, hpr.sigma)
        @player_id_to_temp_rating[player.id] = temp_rating
        @ratings_player_by_player_id[player.id] = Ratings::Player.new(player.name, temp_rating)
      else
        temp_rating = Ratings::NamedRating.new(hbp.player_name, MU, SIGMA)
        @player_id_to_temp_rating[player.id] = temp_rating
        @ratings_player_by_player_id[player.id] = Ratings::Player.new(player.name, temp_rating)
      end
    end

    # Run rating update for the players in the match
    def process_match(match)
      match_date = match.date
      match_players = match.allies_players + match.axis_players

      # # For each player, get last played date
      # # Calculate sigma decay if necessary and update rating
      # match_players.each do |match_player|
      #   weeks_since_last_played = match_player.weeks_since_last_played(match_date)
      #   ts_rating = update_sigma_decay(match_player.ts_rating, weeks_since_last_played)
      #   match_player.ts_rating = ts_rating
      # end

      # Build lists of team ratings
      # Rate the match using the model (first team is the winner)
      allies_ts_ratings = match.allies_players.map { |p| p.ts_rating }
      axis_ts_ratings = match.axis_players.map { |p| p.ts_rating }

      if match.allied_win?
        ts_teams = [allies_ts_ratings, axis_ts_ratings]
      else
        ts_teams = [axis_ts_ratings, allies_ts_ratings]
      end
      puts "match #{match.match_id}"
      puts "allies #{allies_ts_ratings}"
      puts "axis #{axis_ts_ratings}"
      puts "------------------"
      FactorGraph.new(ts_teams, [1, 2]).update_skills

      match_players.each do |mp|
        player = @ratings_player_by_player_id[mp.player_id]
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

      [ts_min, ts_max]
    end

    def normalize_to_elo(mu, old_min, old_max)
      new_min = 1000
      new_max = 2000
      (((mu - old_min) / (old_max - old_min)) * (new_max - new_min) + new_min).to_i
    end
  end
end
