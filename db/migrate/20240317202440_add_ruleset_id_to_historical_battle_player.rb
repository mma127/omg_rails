class AddRulesetIdToHistoricalBattlePlayer < ActiveRecord::Migration[6.1]
  def change
    add_reference :historical_battle_players, :ruleset, foreign_key: true
  end
end
