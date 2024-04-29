class CreateStatsUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :stats_units, comment: "Table for squad level stats, allows duplicate references as multiple const_names may refer to the same reference" do |t|
      t.references :ruleset, null: false, foreign_key: true
      t.string :reference, null: false, comment: "Attrib reference string"
      t.string :const_name, null: false, comment: "SCAR const string, a unique identifier"
      t.jsonb :data, null: false

      t.timestamps
    end

    add_index :stats_units, [:ruleset_id, :reference]
    add_index :stats_units, [:ruleset_id, :const_name], unique: true
  end
end
