require 'http'

class DiscordService < ApplicationService
  def self.notify_looking_for_game(message)
    return if self.looking_for_game_webhook_url.blank?

    self.call_json_webhook(looking_for_game_webhook_url, message)
  end

  private

  def self.looking_for_game_webhook_url
    ENV["DISCORD_LOOKING_FOR_GAME_WEBHOOK_URL"]
  end

  def self.call_json_webhook(url, content)
    HTTP.post(url, json: { content: content })
  end
end
