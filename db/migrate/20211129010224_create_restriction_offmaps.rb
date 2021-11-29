class CreateRestrictionOffmaps < ActiveRecord::Migration[6.1]
  def change
    create_table :restriction_offmaps, comment: "Association of Restriction to Offmap" do |t|
      t.references :restriction, index: true, foreign_key: true
      t.references :offmap, index: true, foreign_key: true
      t.timestamps
    end
  end
end
