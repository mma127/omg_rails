class CreateHistoricalPlayerRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :historical_player_ratings, comment: "" do |t|
      t.string :player_name, comment: "historical player name"
      t.integer :elo, comment: "trueskill mu normalized between 1000 and 2000"
      t.decimal :mu, comment: "trueskill mu"
      t.decimal :sigma, comment: "trueskill sigma"

      t.timestamps
    end
  end
end
