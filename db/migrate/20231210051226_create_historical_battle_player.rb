class CreateHistoricalBattlePlayer < ActiveRecord::Migration[6.1]
  def change
    create_table :historical_battle_players, comment: "Historical record of battle results by player" do |t|
      t.references :player, index: true, null: true
      t.string :player_name, null: false, comment: "Denormalized player name in case player record is deleted"
      t.string :battle_id, null: false, comment: "Battle id, could be duplicates in the long run through multiple war resets"
      t.references :doctrine, index: true, null: false
      t.string :is_winner, null: false, comment: "Whether the player won"
      t.integer :elo, comment: "Trueskill mu normalized, after battle"
      t.float :mu, comment: "Trueskill mu, after battle"
      t.float :sigma, comment: "Trueskill sigma, after battle"
      t.integer :wins, default: 0, comment: "wins to date"
      t.integer :losses, default: 0, comment: "losses to date"

      t.timestamps
    end

    add_index :historical_battle_players, :player_name
  end
end
