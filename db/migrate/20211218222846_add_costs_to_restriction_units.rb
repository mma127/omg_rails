class AddCostsToRestrictionUnits < ActiveRecord::Migration[6.1]
  def change
    add_column :restriction_units, :pop, :decimal, comment: "Population cost"
    add_column :restriction_units, :man, :integer, comment: "Manpower cost"
    add_column :restriction_units, :mun, :integer, comment: "Munition cost"
    add_column :restriction_units, :fuel, :integer, comment: "Fuel cost"
    add_column :restriction_units, :resupply, :integer, comment: "Per game resupply"
    add_column :restriction_units, :resupply_max, :integer, comment: "How much resupply is available from saved up resupplies, <= company max"
    add_column :restriction_units, :company_max, :integer, comment: "Maximum number of the unit a company can hold"
    add_column :restriction_units, :callin_modifier, :decimal, default: 1, comment: "Base callin modifier, default is 1"
    add_column :restriction_units, :priority, :integer, comment: "Priority order to apply the modification from 1 -> 100"
    add_column :restriction_units, :description, :string, comment: "What does this RestrictionUnit do?"
  end
end
