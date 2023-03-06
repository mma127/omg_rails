class CreateUpgrades < ActiveRecord::Migration[6.1]
  def change
    create_table :upgrades do |t|
      t.string :const_name, comment: "Upgrade const name used by the battlefile"
      t.string :name, null: false, comment: "Unique upgrade name"
      t.string :display_name, null: false, comment: "Display upgrade name"
      t.string :description, comment: "Upgrade description"
      t.integer :uses, comment: "Number of uses this upgrade provides"
      t.integer :pop, comment: "Population cost"
      t.integer :man, comment: "Manpower cost"
      t.integer :mun, comment: "Munition cost"
      t.integer :fuel, comment: "Fuel cost"
      t.integer :upgrade_slots, comment: "Upgrade slot cost for per model upgrades"
      t.integer :unitwide_upgrade_slots, comment: "Upgrade slot cost for unit wide upgrades"
      t.integer :model_count, comment: "How many model entities this unit replacement consists of"
      t.integer :additional_model_count, comment: "How many model entities this upgrade adds to the base unit"
      t.boolean :is_building, comment: "Is this upgrade a building to be built"
      t.boolean :is_unit_replace, comment: "Does this upgrade replace units data"
      t.string :type, null: false, comment: "Type of Upgrade"

      t.timestamps
    end
  end
end
