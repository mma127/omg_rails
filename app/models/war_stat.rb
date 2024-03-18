class WarStat
  attr_accessor :wins, :losses, :ratings_sum, :ratings_count, :model, :model_id

  def initialize(model)
    @model_id = model.id
    @model = model
    @wins = 0
    @losses = 0
    @ratings_sum = 0
    @ratings_count = 0
  end

  def add_result(is_win, rating)
    if is_win
      @wins += 1
    else
      @losses += 1
    end

    @ratings_sum += rating
    @ratings_count += 1
  end

  def model_name
    @model.name
  end

  def ratings_avg
    @ratings_sum / @ratings_count
  end

  def win_rate
    games_played = @wins + @losses
    if games_played > 0
      (@wins / (@wins + @losses).to_f).round(4)
    else
      0
    end
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :model_id, as: :id
    expose :model_name, as: :name
    expose :wins
    expose :losses
    expose :ratings_avg, as: :ratingsAvg
    expose :win_rate, as: :winRate
  end
end
