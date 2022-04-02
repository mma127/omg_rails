module Entities
  class BattleMessage < Grape::Entity
    expose :type
    expose :battle, using: Battle::Entity, expose_nil: false
    expose :player, using: Player::Entity, expose_nil: false
  end
end
