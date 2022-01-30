class CreateBattles < ActiveRecord::Migration[6.1]
  def change
    create_table :battles do |t|
      t.string :name, comment: "Optional battle name"
      t.string :state, null: false, comment: "Battle status"
      t.integer :size, null: false, comment: "Size of each team"
      t.string :winner, comment: "Winning side"
      t.references :ruleset, null: false

      t.timestamps
    end

    add_index :battles, :state

    create_table :battle_players do |t|
      t.references :battle, null: false
      t.references :player, null: false
      t.references :company, null: false

      t.string :side, null: false, comment: "Team side"
      t.boolean :abandoned, comment: "Is this player abandoning?"

      t.timestamps
    end
  end
end
