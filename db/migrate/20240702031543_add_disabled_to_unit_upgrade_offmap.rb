class AddDisabledToUnitUpgradeOffmap < ActiveRecord::Migration[7.0]
  def change
    add_column :units, :disabled, :boolean, default: false, null: false, comment: "override that disables the unit from being purchased or used"
    add_column :upgrades, :disabled, :boolean, default: false, null: false, comment: "override that disables the upgrade from being purchased or used"
    add_column :offmaps, :disabled, :boolean, default: false, null: false, comment: "override that disables the offmap from being purchased or used"
  end
end
