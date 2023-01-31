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
  end
end
