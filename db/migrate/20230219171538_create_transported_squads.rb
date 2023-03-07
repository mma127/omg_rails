class CreateTransportedSquads < ActiveRecord::Migration[6.1]
  def change
    create_table :transported_squads, comment: "Association of transport squad to embarked squad" do |t|
      t.references :transport_squad, null: false, index: true, foreign_key: { to_table: :squads }
      t.references :embarked_squad, null: false, foreign_key: { to_table: :squads }

      t.timestamps
    end

    add_index :transported_squads, :embarked_squad_id, unique: true, name: "idx_transported_squads_embarked_squad_uniq"
    add_index :transported_squads, [:transport_squad_id, :embarked_squad_id], unique: true, name: "idx_transported_squads_assoc_uniq"
  end
end
