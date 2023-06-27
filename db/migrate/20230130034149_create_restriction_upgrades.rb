class CreateRestrictionUpgrades < ActiveRecord::Migration[6.1]
  def change
    create_table :restriction_upgrades do |t|
      t.references :restriction, index: true, foreign_key: true
      t.references :upgrade, index: true, foreign_key: true
      t.references :ruleset, index: true, foreign_key: true
      t.string :internal_description, comment: "What does this RestrictionUpgrade do?"
      t.string :type, null: false, comment: "What effect this restriction has on the upgrade"
      t.integer :uses, comment: "Number of uses this upgrade provides"
      t.integer :max, comment: "Maximum number of purchases per unit"
      t.integer :pop, comment: "Population cost"
      t.integer :man, comment: "Manpower cost"
      t.integer :mun, comment: "Munition cost"
      t.integer :fuel, comment: "Fuel cost"
      t.integer :priority, comment: "Priority of this restriction"
      t.integer :upgrade_slots, comment: "Upgrade slot cost for per model upgrades"
      t.integer :unitwide_upgrade_slots, comment: "Upgrade slot cost for unit wide upgrades"

      t.timestamps
    end

    add_index :restriction_upgrades, [:restriction_id, :upgrade_id, :ruleset_id, :type, :uses, :max, :man, :mun, :fuel], unique: true, name: "idx_restriction_upgrades_ruleset_type_uniq"
    add_index :restriction_upgrades, [:ruleset_id, :restriction_id]
    add_index :restriction_upgrades, [:ruleset_id, :upgrade_id]
  end
end
