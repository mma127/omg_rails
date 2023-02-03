class CreateUnitSwaps < ActiveRecord::Migration[6.1]
  def change
    create_table :unit_swaps, comment: "Association of old and new units to swap for an unlock" do |t|
      t.references :unlock, index: true, foreign_key: true, null: false
      t.references :old_unit, null: false, foreign_key: { to_table: :units }
      t.references :new_unit, null: false, foreign_key: { to_table: :units }
      t.string :description, comment: "Description of this UnitSwap"

      t.timestamps
    end
  end
end
