module Ratings
  class BalanceService
    def initialize(battle_id)
      @battle = Battle.includes(battle_players: { player: :player_rating }).find(battle_id)
    end

    # TODO is there a use anymore for this?
    def get_elo_difference
      calculate_elo_difference(@battle.allied_battle_players, @battle.axis_battle_players)
    end

    def find_most_balanced_teams(persist = true)
      # for battle players
      # try all permutations of the elements split in two teams
      team_size = @battle.size
      total_size = @battle.total_size

      lowest_elo_diff = Float::INFINITY
      lowest_elo_diff_team1 = nil
      lowest_elo_diff_team2 = nil
      @battle.battle_players.to_a.permutation do |p|
        team1 = p[0, team_size]
        team2 = p[team_size, total_size]

        abs_elo_diff = calc_absolute_elo_difference(team1, team2)
        if abs_elo_diff < lowest_elo_diff
          lowest_elo_diff = abs_elo_diff
          lowest_elo_diff_team1 = team1
          lowest_elo_diff_team2 = team2
        end
      end

      persist_balance_updates(lowest_elo_diff, lowest_elo_diff_team1, lowest_elo_diff_team2) if persist

      [lowest_elo_diff, sort_battle_players(lowest_elo_diff_team1), sort_battle_players(lowest_elo_diff_team2)]
    end

    def clear_battle_balance_data
      @battle.update!(elo_diff: nil)
      bps = @battle.battle_players.each { |bp| bp.team_balance = nil }.to_a
      BattlePlayer.import! bps, on_duplicate_key_update: { conflict_target: [:id], columns: [:team_balance] }
    end

    private

    def average_elo(battle_players)
      return 0 unless battle_players.size.positive?

      sum = battle_players.sum { |bp| bp.player_elo }

      sum / battle_players.size
    end

    def calc_absolute_elo_difference(team1, team2)
      calculate_elo_difference(team1, team2).abs
    end

    def calculate_elo_difference(team1, team2)
      team1_elo_avg = average_elo(team1)
      team2_elo_avg = average_elo(team2)

      team1_elo_avg - team2_elo_avg
    end

    def sort_battle_players(battle_players)
      battle_players.sort_by { |bp| bp.player.name }
    end

    def persist_balance_updates(elo_diff, battle_players_team1, battle_players_team2)
      ActiveRecord::Base.transaction do
        @battle.update!(elo_diff: elo_diff)
        persist_battle_player_team(battle_players_team1, 1)
        persist_battle_player_team(battle_players_team2, 2)
      end
    end

    def persist_battle_player_team(battle_players, team)
      battle_players.each { |bp| bp.team_balance = team }
      BattlePlayer.import! battle_players.to_a, on_duplicate_key_update: { conflict_target: [:id], columns: [:team_balance] }
    end
  end
end
