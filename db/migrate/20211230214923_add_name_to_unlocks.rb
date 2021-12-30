class AddNameToUnlocks < ActiveRecord::Migration[6.1]
  def change
    add_column :unlocks, :name, :string, null: false, comment: "Unlock internal name"
    add_column :unlocks, :display_name, :string, null: false, comment: "Unlock display name"

    add_index :unlocks, :name, unique: true
  end
end
