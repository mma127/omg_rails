class AddConstraintsToFactions < ActiveRecord::Migration[6.1]
  def change
    change_column_null :factions, :name, false
    change_column_null :factions, :const_name, false
    change_column_null :factions, :display_name, false
    change_column_null :factions, :side, false

    add_index :factions, :name, unique: true
    add_index :factions, :const_name, unique: true
  end
end
