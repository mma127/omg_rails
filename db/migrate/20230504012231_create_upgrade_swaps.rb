class CreateUpgradeSwaps < ActiveRecord::Migration[6.1]
  def change
    create_table :upgrade_swaps, comment: "Association of old and new upgrades to swap for in an unlock" do |t|
      t.references :unlock, index: true, foreign_key: true, null: false
      t.references :old_upgrade, null: false, foreign_key: { to_table: :upgrades }
      t.references :new_upgrade, null: false, foreign_key: { to_table: :upgrades }
      t.string :internal_description, comment: "Internal description of this UpgradeSwap"

      t.timestamps
    end

    # These enforce a 1 to 1 mapping between a specific old_upgrade_id and a specific new_upgrade_id, such that
    # an upgrade swap is reversible because an old upgrade can only be swapped to 1 type of new upgrade and vice versa
    add_index :upgrade_swaps, [:unlock_id, :old_upgrade_id], unique: true
    add_index :upgrade_swaps, [:unlock_id, :new_upgrade_id], unique: true
  end
end
