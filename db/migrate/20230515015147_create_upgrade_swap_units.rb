class CreateUpgradeSwapUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :upgrade_swap_units, comment: "Association of upgrade swap to affected units" do |t|
      t.references :upgrade_swap, index: true, foreign_key: true, null: false
      t.references :unit, index: true, foreign_key: true, null: false

      t.timestamps
    end

    add_index :upgrade_swap_units, [:upgrade_swap_id, :unit_id], unique: true
  end
end
