class BattlesHistoryService < ApplicationService
  def self.fetch_battles_history(ruleset_id)
    Battle
      .includes(battle_players: :player)
      .where(ruleset_id: ruleset_id, state: "final")
      .order(id: :desc)
  end

  def self.fetch_company_battles_history(company_id)
    Battle
      .includes(battle_players: :player)
      .joins(:battle_players)
      .where(state: "final")
      .where(battle_players: { company_id: company_id })
      .order(id: :desc)
  end
end
