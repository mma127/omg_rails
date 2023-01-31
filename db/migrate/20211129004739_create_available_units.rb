class CreateAvailableUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :available_units, comment: "Unit availability per company" do |t|
      t.references :company, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true
      t.integer :available, default: 0, null: false, comment: "Number of this unit available to purchase for the company"
      t.integer :resupply, default: 0, null: false, comment: "Per game resupply"
      t.integer :resupply_max, default: 0, null: false, comment: "How much resupply is available from saved up resupplies, <= company ma"
      t.integer :company_max, default: 0, null: false, comment: "Maximum number of the unit a company can hold"
      t.decimal :pop, null: false, comment: "Calculated pop cost of this unit for the company"
      t.integer :man, null: false, comment: "Calculated man cost of this unit for the company"
      t.integer :mun, null: false, comment: "Calculated mun cost of this unit for the company"
      t.integer :fuel, null: false, comment: "Calculated fuel cost of this unit for the company"
      t.decimal :callin_modifier, null: false, comment: "Calculated base callin modifier of this unit for the company"


      t.timestamps
    end
  end
end
