class AddCostsToAvailableUnits < ActiveRecord::Migration[6.1]
  def change
    add_column :available_units, :pop, :decimal, null: false, comment: "Calculated pop cost of this unit for the company"
    add_column :available_units, :man, :integer, null: false, comment: "Calculated man cost of this unit for the company"
    add_column :available_units, :mun, :integer, null: false, comment: "Calculated mun cost of this unit for the company"
    add_column :available_units, :fuel, :integer, null: false, comment: "Calculated fuel cost of this unit for the company"
    add_column :available_units, :callin_modifier, :decimal, null: false, comment: "Calculated base callin modifier of this unit for the company"
  end
end
