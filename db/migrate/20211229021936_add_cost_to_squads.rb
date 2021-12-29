class AddCostToSquads < ActiveRecord::Migration[6.1]
  def change
    add_reference :squads, :available_unit, null: false
  end
end
