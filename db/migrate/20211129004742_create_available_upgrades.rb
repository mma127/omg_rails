class CreateAvailableUpgrades < ActiveRecord::Migration[6.1]
  def change
    create_table :available_upgrades, comment: "Upgrade availability per company" do |t|
      t.references :company, index: true, foreign_key: true
      t.references :upgrade, index: true, foreign_key: true
      t.string :type, null: false, comment: "Type of available upgrade"
      t.integer :available, comment: "Number of this upgrade available to purchase for the company"
      t.integer :resupply, comment: "Per game resupply"
      t.integer :resupply_max, comment: "How much resupply is available from saved up resupplies, <= company max"
      t.integer :company_max, comment: "Maximum number of the unit a company can hold"
      t.decimal :pop, null: false, comment: "Calculated pop cost of this upgrade for the company"
      t.integer :man, null: false, comment: "Calculated man cost of this upgrade for the company"
      t.integer :mun, null: false, comment: "Calculated mun cost of this upgrade for the company"
      t.integer :fuel, null: false, comment: "Calculated fuel cost of this upgrade for the company"

      t.timestamps
    end

    add_index :available_upgrades, [:company_id, :upgrade_id, :type], unique: true
  end
end
