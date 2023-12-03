class CreatePlayerRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :player_ratings do |t|
      t.references :player, index: true, foreign_key: true
      t.integer :elo, comment: "trueskill mu normalized between 1000 and 2000"
      t.decimal :mu, comment: "trueskill mu"
      t.decimal :sigma, comment: "trueskill sigma"
      t.date :last_played, comment: "last played match"

      t.timestamps
    end
  end
end
