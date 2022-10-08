class AddRaceToFactions < ActiveRecord::Migration[6.1]
  def change
    add_column :factions, :race, :integer, comment: "In-game race id"
  end
end
