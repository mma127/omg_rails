class SimplifyUnitsAsMetadata < ActiveRecord::Migration[6.1]
  def change
    remove_column :units, :pop, :integer
    remove_column :units, :man, :integer
    remove_column :units, :mun, :integer
    remove_column :units, :fuel, :integer
    remove_column :units, :resupply, :integer
    remove_column :units, :resupply_max, :integer
    remove_column :units, :company_max, :integer
    remove_reference :units, :restriction, index: true, foreign_key: true

    add_column :units, :name, :string, null: false, unique: true, comment: "Unique unit name"
    add_column :units, :type, :string, null: false, comment: "Unit type"
    change_column_null :units, :const_name, false
    change_column_null :units, :display_name, false
    change_column_default :units, :is_airdrop, from: nil, to: false
    change_column_default :units, :is_infiltrate, from: nil, to: false
    change_column_null :units, :is_airdrop, false
    change_column_null :units, :is_infiltrate, false
    change_column_default :units, :unitwide_upgrade_slots, from: nil, to: 0
    change_column_default :units, :upgrade_slots, from: nil, to: 0
    change_column_null :units, :unitwide_upgrade_slots, false
    change_column_null :units, :upgrade_slots, false

    add_index :units, :name
  end
end
