module Entities
  class WarStatsResponse < Grape::Entity
    expose :allied_wins, as: :alliedWins
    expose :axis_wins, as: :axisWins
    expose :generated_at, as: :generatedAt
    expose :doctrines, using: WarStat::Entity
    expose :factions, using: WarStat::Entity
  end
end
