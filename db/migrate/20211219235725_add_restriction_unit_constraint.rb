class AddRestrictionUnitConstraint < ActiveRecord::Migration[6.1]
  def change
    add_index :restriction_units, [:restriction_id, :unit_id], unique: true
  end
end
