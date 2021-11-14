class CreateUnitModifications < ActiveRecord::Migration[6.1]
  def change
    create_table :unit_modifications, comment: "Changes unit attributes from faction, doctrine, unlock" do |t|
      t.references :unit, index: true, foreign_key: true
      t.references :faction, index: true, foreign_key: true
      t.references :doctrine, index: true, foreign_key: true
      t.references :unlock, index: true, foreign_key: true
      t.string :const_name, comment: "Replacement const name for the unit used by the battle file"
      t.integer :pop, comment: "Modified population cost"
      t.integer :man, comment: "Modified manpower cost"
      t.integer :mun, comment: "Modified munition cost"
      t.integer :fuel, comment: "Modified fuel cost"
      t.integer :resupply, comment: "Modified resupply per game"
      t.integer :company_max, comment: "Modified company max"
      t.integer :upgrade_slots, comment: "Modified number of slots available for per model weapon upgrades"
      t.integer :unitwide_upgrade_slots, comment: "Modified number of slots available for unit wide weapon replacements"
      t.boolean :is_airdrop, comment: "Replacement flag for whether the unit can airdrop"
      t.boolean :is_infiltrate, comment: "Replacement flag for whether the unit can infiltrate"
      t.decimal :callin_modifier, comment: "Replaces base callin modifier if not 1"
      t.string :type, comment: "Type of modification"
      t.integer :priority, comment: "Priority order to apply the modification from 1 -> 100"

      t.timestamps
    end
  end
end
