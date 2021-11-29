class CreateUpgradeModifications < ActiveRecord::Migration[6.1]
  def change
    create_table :upgrade_modifications, comment: "Changes upgrade attributes from restriction or unlocks" do |t|
      t.references :upgrade, index: true, foreign_key: true
      t.references :unlock, index: true, foreign_key: true
      t.references :restriction, index: true, foreign_key: true
      t.string :const_name, comment: "Replacement upgrade name used by the battle file"
      t.integer :uses, comment: "Modified number of upgrade uses"
      t.integer :pop, comment: "Modified population cost"
      t.integer :man, comment: "Modified manpower cost"
      t.integer :mun, comment: "Modified munition cost"
      t.integer :fuel, comment: "Modified fuel cost"
      t.integer :upgrade_slots, comment: "Modified upgrade slot cost for per model upgrades"
      t.integer :unitwide_upgrade_slots, comment: "Modified upgrade slot cost for unit wide upgrades"
      t.boolean :is_building, comment: "Replacement flag for whether this upgrade is a building to be built"
      t.boolean :is_unit_replace, comment: "Replacement flag for whether this upgrade replaces units data"
      t.string :type, comment: "Type of modification"
      t.integer :priority, comment: "Priority order to apply the modification from 1 -> 100"

      t.timestamps
    end
  end
end
