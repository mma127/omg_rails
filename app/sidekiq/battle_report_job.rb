class BattleReportJob
  include Sidekiq::Job

  def perform(battle_id, is_final, reporting_player_name, time_elapsed, race_winner, map_name,
              dead_squads, surviving_squads, dropped_players, battle_stats)
    # Rails.logger.info("Processing battle report for battle #{battle_id}")
    # Rails.logger.info("Final flag: #{is_final}, Race Winner: #{race_winner}, Reporting Player:#{reporting_player_name}")
    service = BattleReportService.new(battle_id)
    service.process_report(battle_id, is_final, reporting_player_name, time_elapsed, race_winner, map_name,
                           dead_squads, surviving_squads, dropped_players, battle_stats)
  rescue StandardError => e
    Rails.logger.error(e)
    Sentry.capture_exception(e)
    raise e
  end
end
