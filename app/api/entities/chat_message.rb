module Entities
  class ChatMessage < Grape::Entity
    expose :id
    expose :sender, using: Player::Entity, expose_nil: false

  end
end
