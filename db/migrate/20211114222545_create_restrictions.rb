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

    add_index :restrictions, [:faction_id, :doctrine_id, :doctrine_unlock_id, :unlock_id], unique: true, name: "idx_restrictions_uniq_id"
  end
end
