class CreateRestrictions < ActiveRecord::Migration[6.1]
  def change
    create_table :restrictions do |t|
      t.string :name, comment: "Restriction name"
      t.text :description, comment: "Restriction description"
      t.references :faction, index: true, foreign_key: true
      t.references :doctrine, index: true, foreign_key: true
      t.references :doctrine_unlock, index: true, foreign_key: true
      t.references :unlock, index: true, foreign_key: true
      t.integer :vet_requirement, comment: "Minimum veterancy requirement"

      t.timestamps
    end

    # Partial indexes
    add_index :restrictions, :faction_id, unique: true, where: "faction_id IS NOT NULL", name: "unique_not_null_faction_id"
    add_index :restrictions, :doctrine_id, unique: true, where: "doctrine_id IS NOT NULL", name: "unique_not_null_doctrine_id"
    add_index :restrictions, :doctrine_unlock_id, unique: true, where: "doctrine_unlock_id IS NOT NULL", name: "unique_not_null_doctrine_unlock_id"
    add_index :restrictions, :unlock_id, unique: true, where: "unlock_id IS NOT NULL", name: "unique_not_null_unlock_id"
  end
end
