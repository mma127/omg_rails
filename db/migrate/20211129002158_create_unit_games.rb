class CreateUnitGames < ActiveRecord::Migration[6.1]
  def change
    create_table :unit_games do |t|
      t.references :unit, index: true, foreign_key: true
      t.references :game, index: true, foreign_key: true

      t.timestamps
    end
  end
end
