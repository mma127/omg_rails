module Entities
  class BattleHistoryResponse < Grape::Entity
    expose :id
    expose :name
    expose :size
    expose :winner
    expose :map
    expose :updated_at, as: :datetime
    expose :battle_players, as: :battlePlayers, using: BattlePlayer::HistoryEntity
  end
end
