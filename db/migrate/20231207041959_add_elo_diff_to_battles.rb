class AddEloDiffToBattles < ActiveRecord::Migration[6.1]
  def change
    add_column :battles, :elo_diff, :integer, comment: "Elo difference between most balanced teams, absolute value"
  end
end
