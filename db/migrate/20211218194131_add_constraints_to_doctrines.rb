class AddConstraintsToDoctrines < ActiveRecord::Migration[6.1]
  def change
    change_column_null :doctrines, :name, false
    change_column_null :doctrines, :const_name, false
    change_column_null :doctrines, :display_name, false
    change_column_null :doctrines, :faction_id, false

    add_index :doctrines, :name, unique: true
    add_index :doctrines, :const_name, unique: true
  end
end
