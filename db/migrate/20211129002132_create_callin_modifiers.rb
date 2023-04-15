class CreateCallinModifiers < ActiveRecord::Migration[6.1]
  def change
    create_table :callin_modifiers do |t|
      t.decimal :modifier, comment: "Modifies callin time"
      t.string :modifier_type, comment: "Type of modification"
      t.integer :priority, comment: "Priority in which the modifier is applied, from 1 -> 100"
      t.string :description, comment: "Description"
      t.string :unlock_name, comment: "Name of the unlock associated with this callin modifier"

      t.timestamps
    end
  end
end
