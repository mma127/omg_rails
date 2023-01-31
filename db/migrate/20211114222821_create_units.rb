class CreateUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :units, comment: "Metadata for a unit" do |t|
      t.string :name, null: false, comment: "Unique unit name"
      t.string :type, null: false, comment: "Unit type"
      t.string :const_name, null: false, comment: "Const name of the unit for the battle file"
      t.string :display_name, null: false, comment: "Display name"
      t.text :description, comment: "Display description of the unit"
      t.integer :upgrade_slots, null: false, default: 0, comment: "Slots used for per model weapon upgrades"
      t.integer :unitwide_upgrade_slots, null: false, default: 0, comment: "Unit wide weapon replacement slot"
      t.boolean :is_airdrop, null: false, default: false, comment: "Is this unit airdroppable?"
      t.boolean :is_infiltrate, null: false, default: false, comment: "Is this unit able to infiltrate?"
      t.string :retreat_name, comment: "Name for retreating unit"

      t.timestamps
    end

    add_index :units, :name, unique: true
  end
end
