class AddTeamAssignmentToBattlePlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :battle_players, :team_balance, :integer, comment: "Assigned team for balance"
  end
end
