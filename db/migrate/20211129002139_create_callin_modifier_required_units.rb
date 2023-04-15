class CreateCallinModifierRequiredUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :callin_modifier_required_units, comment: "Unit required for the callin modifier to be applied" do |t|
      t.references :callin_modifier, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true
      t.string :unit_name, comment: "Denormalized unit name for faster access"

      t.timestamps
    end
  end
end
