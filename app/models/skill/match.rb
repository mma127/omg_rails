module Skill
  class Match
    attr_accessor :match_id, :winner, :date, :allies_players, :axis_players
    def initialize(match_id, winner, date)
      @match_id = match_id
      @winner = winner
      @date = date
      @allies_players = []
      @axis_players = []
    end

    def add_player(match_player)
      if match_player.side == "Allies"
        @allies_players << match_player
      else
        @axis_players << match_player
      end
    end

    def allied_win?
      @winner == "Allies"
    end
  end
end