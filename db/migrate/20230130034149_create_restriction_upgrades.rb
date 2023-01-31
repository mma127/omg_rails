class CreateRestrictionUpgrades < ActiveRecord::Migration[6.1]
  def change
    create_table :restriction_upgrades do |t|
      t.references :restriction, index: true, foreign_key: true
      t.references :upgrade, index: true, foreign_key: true
      t.references :ruleset, index: true, foreign_key: true
      t.string :description, comment: "What does this RestrictionUpgrade do?"
      t.string :type, null: false, comment: "What effect this restriction has on the upgrade"
      t.integer :uses, comment: "Number of uses this upgrade provides"
      t.integer :pop, comment: "Population cost"
      t.integer :man, comment: "Manpower cost"
      t.integer :mun, comment: "Munition cost"
      t.integer :fuel, comment: "Fuel cost"
      t.integer :priority, comment: "Priority of this restriction"

      t.timestamps
    end
  end
end
