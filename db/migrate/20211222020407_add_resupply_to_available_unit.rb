class AddResupplyToAvailableUnit < ActiveRecord::Migration[6.1]
  def change
    add_column :available_units, :resupply, :integer, null: false, comment: "Per game resupply"
    add_column :available_units, :resupply_max, :integer, null: false, comment: "How much resupply is available from saved up resupplies, <= company ma"
    add_column :available_units, :company_max, :integer, null: false, comment: "Maximum number of the unit a company can hold"
  end
end
