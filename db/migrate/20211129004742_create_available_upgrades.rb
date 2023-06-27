class CreateAvailableUpgrades < ActiveRecord::Migration[6.1]
  def change
    create_table :available_upgrades, comment: "Upgrade availability per company and unit" do |t|
      t.references :company, index: true, foreign_key: true
      t.references :upgrade, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true
      t.string :type, null: false, comment: "Type of available upgrade"
      t.decimal :pop, null: false, comment: "Calculated pop cost of this upgrade for the company"
      t.integer :man, null: false, comment: "Calculated man cost of this upgrade for the company"
      t.integer :mun, null: false, comment: "Calculated mun cost of this upgrade for the company"
      t.integer :fuel, null: false, comment: "Calculated fuel cost of this upgrade for the company"
      t.integer :uses, comment: "Uses of this upgrade"
      t.integer :max, comment: "Maximum number of this upgrade purchasable by a unit"
      t.integer :upgrade_slots, comment: "Upgrade slot cost for per model upgrades"
      t.integer :unitwide_upgrade_slots, comment: "Upgrade slot cost for unit wide upgrades"

      t.timestamps
    end

    add_index :available_upgrades, [:company_id, :upgrade_id, :unit_id, :type], unique: true, name: "idx_available_upgrade_uniq"
  end
end
