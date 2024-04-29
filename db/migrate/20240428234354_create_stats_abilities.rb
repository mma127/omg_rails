class CreateStatsAbilities < ActiveRecord::Migration[7.0]
  def change
    create_table :stats_abilities do |t|
      t.references :ruleset, null: false, foreign_key: true
      t.string :reference, null: false, comment: "Attrib reference string, a unique identifier"
      t.jsonb :data, null: false

      t.timestamps
    end

    add_index :stats_abilities, [:ruleset_id, :reference], unique: true
  end
end
