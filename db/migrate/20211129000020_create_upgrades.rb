class CreateUpgrades < ActiveRecord::Migration[6.1]
  def change
    create_table :upgrades do |t|
      t.string :const_name, comment: "Upgrade const name used by the battlefile"
      t.references :restriction, index: true, foreign_key: true
      t.integer :uses, comment: "Number of uses this upgrade provides"
      t.integer :pop, comment: "Population cost"
      t.integer :man, comment: "Manpower cost"
      t.integer :mun, comment: "Munition cost"
      t.integer :fuel, comment: "Fuel cost"
      t.integer :upgrade_slots, comment: "Upgrade slot cost for per model upgrades"
      t.integer :unitwide_upgrade_slots, comment: "Upgrade slot cost for unit wide upgrades"
      t.boolean :is_building, comment: "Is this upgrade a building to be built"
      t.boolean :is_unit_replace, comment: "Does this upgrade replace units data"

      t.timestamps
    end
  end
end
