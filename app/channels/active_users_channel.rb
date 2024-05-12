class ActiveUsersChannel < ApplicationCable::Channel

  CHANNEL = "active_users_channel"

  periodically :transmit_active, every: 60.seconds

  def subscribed
    # Rails.logger.info("#{@connection.current_player&.name} subscribed to #{CHANNEL}")
    stream_from CHANNEL
    transmit_active
  end

  def receive(message)
    ActionCable.server.broadcast CHANNEL, message
  end

  def unsubscribed
    # Rails.logger.info("#{@connection.current_player&.name} unsubscribed from #{CHANNEL}")
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def transmit_active
    @connection.current_player&.try :touch
    ActionCable.server.broadcast CHANNEL, active_users_list
  end

  def active_users_list
    Rails.cache.fetch("active_users", expires_in: 60.seconds) do
      # Rails.logger.info("Fetching active players list")
      active_players = Player.online
      active_players.pluck(:name).sort
    end
  end
end
