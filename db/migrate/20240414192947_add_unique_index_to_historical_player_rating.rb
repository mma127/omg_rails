class AddUniqueIndexToHistoricalPlayerRating < ActiveRecord::Migration[6.1]
  def change
    add_index :historical_player_ratings, :player_name, unique: true
  end
end
