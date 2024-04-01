class RefactorRestrictionsUniqueIndexes < ActiveRecord::Migration[6.1]
  def change
    # Partial indexes
    remove_index :restrictions, name: "idx_restrictions_uniq_id"
    add_index :restrictions, :faction_id, unique: true, where: "faction_id IS NOT NULL", name: "unique_not_null_faction_id"
    add_index :restrictions, :doctrine_id, unique: true, where: "doctrine_id IS NOT NULL", name: "unique_not_null_doctrine_id"
    add_index :restrictions, :doctrine_unlock_id, unique: true, where: "doctrine_unlock_id IS NOT NULL", name: "unique_not_null_doctrine_unlock_id"
    add_index :restrictions, :unlock_id, unique: true, where: "unlock_id IS NOT NULL", name: "unique_not_null_unlock_id"
  end
end
