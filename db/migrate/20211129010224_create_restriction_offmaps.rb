class CreateRestrictionOffmaps < ActiveRecord::Migration[6.1]
  def change
    create_table :restriction_offmaps, comment: "Association of Restriction to Offmap" do |t|
      t.references :restriction, index: true, foreign_key: true
      t.references :offmap, index: true, foreign_key: true
      t.references :ruleset, index: true, foreign_key: true
      t.string :internal_description, null: false, comment: "What does this RestrictionOffmap do?"
      t.string :type, null: false, comment: "What effect this restriction has on the offmap"
      t.integer :max, comment: "Maximum number purchasable"
      t.integer :mun, comment: "Munitions cost"

      t.timestamps
    end
  end
end
