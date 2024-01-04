class BattleNotificationService < ApplicationService
  NOTIFICATION_COOLDOWN = 120

  def initialize(battle_id)
    @battle = Battle.includes(battle_players: :player).find(battle_id)
  end

  def notify_battle_full
    return if notified_too_recently

    discord_ids = build_list_of_discord_ids
    msg = "Game #{@battle.id} is full.\n#{discord_ids.join(" ")}"
    DiscordService.notify_looking_for_game(msg)
    @battle.update!(last_notified: Time.now)
  end

  private

  def notified_too_recently
    if @battle.last_notified && (Time.current - @battle.last_notified) < NOTIFICATION_COOLDOWN
      true
    else
      false
    end
  end

  def build_list_of_discord_ids
    @battle.players.map do |p|
      if p.discord_id.present?
        "<@#{p.discord_id}>"
      else
        p.name
      end
    end
  end
end
