class BattlesHistoryService < ApplicationService
  def self.fetch_battles_history(ruleset_id)
    Rails.cache.fetch("ruleset_#{ruleset_id}_battles_history", expires_in: 5.minutes) do
      Battle
        .includes(battle_players: :player)
        .where(ruleset_id: ruleset_id, state: "final")
        .order(id: :desc)
    end
  end

  def self.fetch_company_battles_history(company_id)
    Rails.cache.fetch("company_#{company_id}_battles_history", expires_in: 5.minutes) do
      Battle
        .includes(battle_players: :player)
        .joins(:battle_players)
        .where(state: "final")
        .where(battle_players: { company_id: company_id })
        .order(id: :desc)
    end
  end
end
