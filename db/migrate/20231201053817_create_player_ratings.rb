class CreatePlayerRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :player_ratings do |t|
      t.references :player, index: true, foreign_key: true
      t.integer :elo, comment: "trueskill mu normalized between 1000 and 2000"
      t.float :mu, comment: "trueskill mu"
      t.float :sigma, comment: "trueskill sigma"
      t.date :last_played, comment: "last played match"
      t.integer :wins, default: 0, comment: "wins to date"
      t.integer :losses, default: 0, comment: "losses to date"

      t.timestamps
    end

    add_index :player_ratings, :mu
  end
end
