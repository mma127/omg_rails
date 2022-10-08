class BattlefileGenerationJob
  include Sidekiq::Job

  def perform(battle_id)
    Rails.logger.info("Generating battle files for battle #{battle_id}")
    battle = Battle.find(battle_id)
    if battle.blank?
      Rails.logger.info("Could not find Battle matching id #{battle_id}")
      return
    end
    unless battle.players_ready?
      Rails.logger.info("Cannot generate battlefile for battle #{battle_id} with players not ready")
      return
    end

    service = BattlefileService.new(battle_id)
    service.generate_files
    Rails.logger.info("Successfully generated battle files for battle #{battle_id}")

    battle.generated!
    Rails.logger.info("Updated battle state to #{battle.reload.state}")
    Rails.logger.info("Pushing #{BattleService::BATTLEFILE_GENERATED} message to ActionCable")
    message_hash = { type: BattleService::BATTLEFILE_GENERATED, battle: battle }
    battle_message = Entities::BattleMessage.represent message_hash, type: :include_players
    ActionCable.server.broadcast BattlesChannel::CHANNEL, battle_message
  end
end
