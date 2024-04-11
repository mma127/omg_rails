class AddRulesetIdToUnlocksNameUniqueIndex < ActiveRecord::Migration[6.1]
  def change
    remove_index :unlocks, :name, unique: true
    remove_index :doctrine_unlocks, [:doctrine_id, :tree, :branch, :row], unique: true, name: "index_doctrine_unlocks_on_doctrine_tree"
    add_index :unlocks, [:name, :ruleset_id], unique: true
    add_index :doctrine_unlocks, [:doctrine_id, :tree, :branch, :row, :ruleset_id], unique: true, name: "index_doctrine_unlocks_on_doctrine_tree"
  end
end
