class CreateUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :units, comment: "Metadata for a unit" do |t|
      t.string :const_name, comment: "Const name of the unit for the battle file"
      t.string :display_name, comment: "Display name"
      t.text :description, comment: "Display description of the unit"
      t.integer :pop, comment: "Population cost"
      t.integer :man, comment: "Manpower cost"
      t.integer :mun, comment: "Munition cost"
      t.integer :fuel, comment: "Fuel cost"
      t.integer :resupply, comment: "Per game resupply"
      t.integer :resupply_max, comment: "How much resupply is available from saved up resupplies, <= company max"
      t.integer :company_max, comment: "Maximum number of the unit a company can hold"
      t.integer :upgrade_slots, comment: "Slots used for per model weapon upgrades"
      t.integer :unitwide_upgrade_slots, comment: "Unit wide weapon replacement slot"
      t.boolean :is_airdrop, comment: "Is this unit airdroppable?"
      t.boolean :is_infiltrate, comment: "Is this unit able to infiltrate?"
      t.string :retreat_name, comment: "Name for retreating unit"

      t.timestamps
    end
  end
end
