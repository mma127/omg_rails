class CreateRestrictionUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :restriction_units, comment: "Association of Restriction to Unit" do |t|
      t.references :restriction, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true
      t.references :ruleset, index: true, foreign_key: true
      t.string :description, null: false, comment: "What does this RestrictionUnit do?"
      t.string :type, null: false, comment: "What effect this restriction has on the unit"
      t.decimal :pop, comment: "Population cost"
      t.integer :man, comment: "Manpower cost"
      t.integer :mun, comment: "Munition cost"
      t.integer :fuel, comment: "Fuel cost"
      t.integer :resupply, comment: "Per game resupply"
      t.integer :resupply_max, comment: "How much resupply is available from saved up resupplies, <= company max"
      t.integer :company_max, comment: "Maximum number of the unit a company can hold"
      t.decimal :callin_modifier, default: 1, comment: "Base callin modifier, default is 1"
      t.integer :priority, comment: "Priority order to apply the modification from 1 -> 100"

      t.timestamps
    end

    add_index :restriction_units, [:restriction_id, :unit_id, :ruleset_id], unique: true, name: "index_restriction_units_restriction_unit_ruleset"
    add_index :restriction_units, [:restriction_id, :ruleset_id]
    add_index :restriction_units, [:unit_id, :ruleset_id]
  end
end
