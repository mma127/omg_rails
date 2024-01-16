require 'saulabs/trueskill'

include Saulabs::TrueSkill

module Ratings
  class UpdateService
    class RatingsUpdateValidationError < StandardError; end

    WEEKLY_DECAY = 0.05
    SIGMA = 25.0 / 3.0

    def initialize(battle_id)
      @battle = Battle.includes(battle_players: { player: :player_rating }).find(battle_id)
    end

    def update_player_ratings(winner)
      allied_player_ratings = @battle.allied_battle_players.map { |bp| bp.player.player_rating }
      axis_player_ratings = @battle.axis_battle_players.map { |bp| bp.player.player_rating }

      allied_ts_ratings = allied_player_ratings.map { |pr| update_sigma_decay(pr.ts_rating, pr.weeks_since_last_played) }
      axis_ts_ratings = axis_player_ratings.map { |pr| update_sigma_decay(pr.ts_rating, pr.weeks_since_last_played) }

      team_ratings_list = create_team_ratings_list(winner, allied_ts_ratings, axis_ts_ratings)
      calculate_team_ratings(team_ratings_list)

      time_played = Time.now

      PlayerRating.transaction do
        update_team_players(winner == allied, allied_player_ratings, allied_ts_ratings, time_played)
        update_team_players(winner == axis, axis_player_ratings, axis_ts_ratings, time_played)

        # Should this be async?
        reconcile_player_elo
      end
    end

    private

    def allied
      Battle.winners[:allied]
    end

    def axis
      Battle.winners[:axis]
    end

    def update_sigma_decay(ts_rating, weeks_since_last_played)
      # within 3 weeks, no decay
      if weeks_since_last_played > 3
        weeks_since_last_played -= 3

        sigma_decay = WEEKLY_DECAY * weeks_since_last_played
        ts_rating = ::Ratings::NamedRating.new(ts_rating.name, ts_rating.mean, [SIGMA, ts_rating.deviation + sigma_decay].min)
      end
      ts_rating
    end

    def create_team_ratings_list(winner, allied_ts_ratings, axis_ts_ratings)
      case winner
      when allied
        [allied_ts_ratings, axis_ts_ratings]
      when axis
        [axis_ts_ratings, allied_ts_ratings]
      else
        throw RatingsUpdateValidationError.new("Invalid winner for battle ratings update #{winner}")
      end
    end

    def calculate_team_ratings(team_ratings_list)
      FactorGraph.new(team_ratings_list, [1, 2]).update_skills
    end

    def update_team_players(is_winner, player_ratings, ts_ratings, time_played)
      player_ratings.each_with_index do |player_rating, index|
        ts_rating = ts_ratings[index]

        # Update player rating ts values
        player_rating.mu = ts_rating.mean
        player_rating.sigma = ts_rating.deviation

        # Update player rating win loss
        player_rating.wins += is_winner ? 1 : 0
        player_rating.losses += is_winner ? 0 : 1

        player_rating.last_played = time_played
      end

      PlayerRating.import! player_ratings,
                           on_duplicate_key_update: { conflict_target: [:id], columns: [:mu, :sigma, :wins, :losses, :last_played] }
    end

    # Renormalize all player elos with the results of this battle
    def reconcile_player_elo
      max_mu = PlayerRating.maximum(:mu)
      min_mu = PlayerRating.minimum(:mu)

      player_ratings = PlayerRating.all.to_a
      player_ratings.each do |p|
        p.elo = normalize_to_elo(p.mu, min_mu, max_mu)
      end

      PlayerRating.import! player_ratings,
                           on_duplicate_key_update: { conflict_target: [:id], columns: [:elo] }
    end

    def normalize_to_elo(mu, old_min, old_max)
      new_min = 1000
      new_max = 2000
      ((mu - old_min) / (old_max - old_min)) * (new_max - new_min) + new_min
    end
  end
end
