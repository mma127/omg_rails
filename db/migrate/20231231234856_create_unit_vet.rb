class CreateUnitVet < ActiveRecord::Migration[6.1]
  def change
    create_table :unit_vets, comment: "Unit veterancy levels and descriptions" do |t|
      t.references :unit, index: true, null: false
      t.integer :vet1_exp, default: 0, null: false
      t.string :vet1_desc, null: false
      t.integer :vet2_exp, default: 0, null: false
      t.string :vet2_desc, null: false
      t.integer :vet3_exp, default: 0, null: false
      t.string :vet3_desc, null: false
      t.integer :vet4_exp, default: 0, null: false
      t.string :vet4_desc, null: false
      t.integer :vet5_exp, default: 0, null: false
      t.string :vet5_desc, null: false

      t.timestamps
    end

    add_index :unit_vets, :unit_id, unique: true, name: "idx_unit_vet_unit_id_uniq"
  end
end
