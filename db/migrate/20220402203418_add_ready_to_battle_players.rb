class AddReadyToBattlePlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :battle_players, :ready, :boolean, :default => false, comment: "Ready flag for the player"
  end
end
