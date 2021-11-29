class CreateRestrictionUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :restriction_units, comment: "Association of Restriction to Unit" do |t|
      t.references :restriction, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true

      t.timestamps
    end
  end
end
