class AddNameUniqueIndexToUpgrades < ActiveRecord::Migration[6.1]
  def change
    add_index :upgrades, :name, unique: true
  end
end
