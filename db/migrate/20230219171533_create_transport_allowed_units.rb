class CreateTransportAllowedUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :transport_allowed_units, comment: "Association of transport units and the units they are allowed to transport" do |t|
      t.references :transport, null: false, index: true, foreign_key: { to_table: :units }
      t.references :allowed_unit, null: false, foreign_key: { to_table: :units }
      t.string :internal_description, comment: "Internal description of this TransportAllowedUnit"

      t.timestamps
    end

    add_index :transport_allowed_units, [:transport_id, :allowed_unit_id], unique: true, name: "idx_transport_allowed_units_uniq"
  end
end
