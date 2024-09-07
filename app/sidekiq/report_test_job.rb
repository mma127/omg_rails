class ReportTestJob
  include Sidekiq::Job

  def perform(battle_id)

    battle = Battle.find(battle_id)
    Rails.logger.info("Found battle #{battle_id}")
    battle.with_lock do
      Rails.logger.info("Starting transaction with lock")
      sleep(10)
      Rails.logger.info("End transaction")
    end
  rescue StandardError => e
    Rails.logger.error(e)
    raise e
  end
end
