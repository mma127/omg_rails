class CreateStatsDocMarkers < ActiveRecord::Migration[7.0]
  def change
    create_table :stats_doc_markers do |t|
      t.references :ruleset, null: false, foreign_key: true
      t.string :const_name, null: false
      t.string :reference, null: false
      t.string :faction, null: false

      t.timestamps
    end

    add_index :stats_doc_markers, [:ruleset_id, :reference], unique: true
  end
end
