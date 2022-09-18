class BattlesChannel < ApplicationCable::Channel

  CHANNEL = "battles_channel"

  def subscribed
    Rails.logger.info("#{@connection.current_player.name} subscribed to #{CHANNEL}")
    stream_from CHANNEL
  end

  def receive(message)
    ActionCable.server.broadcast CHANNEL, message
  end

  def unsubscribed
    Rails.logger.info("#{@connection.current_player.name} unsubscribed from #{CHANNEL}")
    # Any cleanup needed when channel is unsubscribed
  end
end
