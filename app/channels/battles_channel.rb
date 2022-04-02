class BattlesChannel < ApplicationCable::Channel

  CHANNEL = "battles_channel"

  def subscribed
    stream_from CHANNEL
  end

  def receive(message)
    ActionCable.server.broadcast CHANNEL, message
  end

  def unsubscribed
    Rails.logger.info("Unsubscribed from #{CHANNEL}")
    # Any cleanup needed when channel is unsubscribed
  end
end
