class CreateRestrictionCallinModifiers < ActiveRecord::Migration[6.1]
  def change
    create_table :restriction_callin_modifiers, comment: "Association of Restriction to CallinModifier" do |t|
      t.references :restriction, index: true, foreign_key: true
      t.references :callin_modifier, index: true, foreign_key: true
      t.references :ruleset, index: true, foreign_key: true
      t.string :internal_description, null: false, comment: "What does this RestrictionCallinModifier do?"
      t.string :type, null: false, comment: "What effect this restriction has on the callin modifier"

      t.timestamps
    end
  end
end
