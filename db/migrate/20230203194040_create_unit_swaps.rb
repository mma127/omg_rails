class CreateUnitSwaps < ActiveRecord::Migration[6.1]
  def change
    create_table :unit_swaps, comment: "Association of old and new units to swap for an unlock" do |t|
      t.references :unlock, index: true, foreign_key: true, null: false
      t.references :old_unit, null: false, foreign_key: { to_table: :units }
      t.references :new_unit, null: false, foreign_key: { to_table: :units }
      t.string :internal_description, comment: "Internal description of this UnitSwap"

      t.timestamps
    end

    # These enforce a 1 to 1 mapping between a specific old_unit_id and a specific new_unit_id, such that
    # a unit swap is reversible because an old unit can only be swapped to 1 type of new unit and vice versa
    add_index :unit_swaps, [:unlock_id, :old_unit_id], unique: true
    add_index :unit_swaps, [:unlock_id, :new_unit_id], unique: true
  end
end
