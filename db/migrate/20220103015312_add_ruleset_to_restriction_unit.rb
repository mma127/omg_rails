class AddRulesetToRestrictionUnit < ActiveRecord::Migration[6.1]
  def change
    add_reference :restriction_units, :ruleset, null: false

    remove_index :restriction_units, [:restriction_id]
    remove_index :restriction_units, [:unit_id]
    remove_index :restriction_units, [:restriction_id, :unit_id], unique: true
    add_index :restriction_units, [:restriction_id, :unit_id, :ruleset_id], unique: true, name: "index_restriction_units_restriction_unit_ruleset"
    add_index :restriction_units, [:restriction_id, :ruleset_id]
    add_index :restriction_units, [:unit_id, :ruleset_id]
  end
end
