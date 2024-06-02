class AddUniqIndexToOffmaps < ActiveRecord::Migration[7.0]
  def change
    add_index :offmaps, [:name, :ruleset_id], unique: true
  end
end
