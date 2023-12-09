module Ratings
  class MatchPlayer
    attr_accessor :name, :side, :ts_rating, :last_played
    def initialize(name, side, ts_rating, last_played)
      @name = name
      @side = side
      @ts_rating = ts_rating
      @last_played = last_played
    end

    def weeks_since_last_played(now)
      # First game, don't worry about time gap
      if @last_played.blank?
        return 0
      end

      delta = now - @last_played
      (delta / 7).to_i
    end
  end
end
