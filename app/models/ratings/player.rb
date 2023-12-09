module Ratings
  class Player
    attr_accessor :name, :ts_rating, :last_played, :games_played, :wins, :losses

    def initialize(name, ts_rating)
      @name = name
      @ts_rating = ts_rating
      @last_played = nil
      @games_played = 0
      @wins = 0
      @losses = 0
    end

    def update_ts_rating(ts_rating, last_played)
      @ts_rating = ts_rating
      @last_played = last_played
    end

    def update_win_loss(is_win)
      @wins += is_win ? 1 : 0
      @losses += is_win ? 0 : 1
      @games_played += 1
    end
  end
end
