class RemoveUnitFromSquad < ActiveRecord::Migration[6.1]
  def change
    remove_reference :squads, :unit, index: true, foreign_key: true
  end
end
