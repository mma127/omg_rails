class WarStatsService < ApplicationService
  def self.fetch_stats(ruleset_id)
    # Maybe use a job to create these regularly?
    Rails.cache.fetch("war_stats", expires_in: 4.hours) do
      process_stats(ruleset_id)
    end
  end

  private

  def self.process_stats(ruleset_id)
    # Generated at timestamp
    current_time = Time.now

    # Fetch all HBP for the current war, in order of id
    hbps = HistoricalBattlePlayer.includes(:faction, :doctrine).where(ruleset_id: ruleset_id).order(:id)

    doctrine_stats_by_id = create_doctrine_stats_models
    faction_stats_by_id = create_faction_stats_models

    allied_wins = 0
    axis_wins = 0

    current_battle_id = nil
    hbps.each do |hbp|
      # Set current battle id
      if current_battle_id != hbp.battle_id
        current_battle_id = hbp.battle_id

        if hbp.faction.side == Faction.sides[:allied]
          allied_wins += 1
        else
          axis_wins += 1
        end
      end

      doctrine_stat = doctrine_stats_by_id[hbp.doctrine_id]
      faction_stat = faction_stats_by_id[hbp.faction_id]

      update_model_stat(doctrine_stat, hbp)
      update_model_stat(faction_stat, hbp)
    end

    {
      doctrines: doctrine_stats_by_id.values.sort_by(&:win_rate).reverse!,
      factions: faction_stats_by_id.values.sort_by(&:win_rate).reverse!,
      allied_wins: allied_wins,
      axis_wins: axis_wins,
      generated_at: current_time
    }.with_indifferent_access
  end

  def self.create_doctrine_stats_models
    Doctrine.all.map { |d| WarStat.new(d) }.index_by(&:model_id)
  end

  def self.create_faction_stats_models
    Faction.all.map { |f| WarStat.new(f) }.index_by(&:model_id)
  end

  def self.update_model_stat(model_stat, hbp)
    model_stat.add_result(hbp.is_winner, hbp.elo)
  end
end
