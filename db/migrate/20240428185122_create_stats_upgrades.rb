class CreateStatsUpgrades < ActiveRecord::Migration[7.0]
  def change
    create_table :stats_upgrades do |t|
      t.references :ruleset, null: false, foreign_key: true
      t.string :reference, null: false, comment: "Attrib reference string, a unique identifier"
      t.string :const_name, comment: "SCAR const string, optional"
      t.jsonb :data, null: false

      t.timestamps
    end

    add_index :stats_upgrades, [:ruleset_id, :reference, :const_name], unique: true
    add_index :stats_upgrades, [:ruleset_id, :const_name], unique: true, where: "const_name IS NOT NULL"
  end
end
