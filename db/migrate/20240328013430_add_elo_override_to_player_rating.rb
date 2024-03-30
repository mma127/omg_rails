class AddEloOverrideToPlayerRating < ActiveRecord::Migration[6.1]
  def change
    add_column :player_ratings, :elo_override, :integer, comment: "Override elo to provide a handicap"
  end
end
