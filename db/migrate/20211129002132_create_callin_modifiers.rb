class CreateCallinModifiers < ActiveRecord::Migration[6.1]
  def change
    create_table :callin_modifiers do |t|
      t.references :restriction, index: true, foreign_key: true
      t.decimal :modifier, comment: "Modifies callin time"
      t.string :type, comment: "Type of modification"
      t.integer :priority, comment: "Priority in which the modifier is applied, from 1 -> 100"

      t.timestamps
    end
  end
end
