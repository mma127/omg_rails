module Ratings
  class BattleRatingsService

    def initialize(battle)
      @battle = battle
    end

    def get_elo_difference
      allied_elo_avg = average_elo(@battle.allied_battle_players)
      axis_elo_avg = average_elo(@battle.axis_battle_players)

      allied_elo_avg - axis_elo_avg
    end

    private

    def average_elo(battle_players)
      sum = battle_players.sum { |bp| bp.player.player_rating.elo }

      sum / battle_players.size
    end

  end
end
