class AddDroppedToBattlePlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :battle_players, :is_dropped, :boolean, default: false, comment: "Has this player dropped?"
  end
end
