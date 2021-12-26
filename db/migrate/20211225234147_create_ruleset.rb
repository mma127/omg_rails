class CreateRuleset < ActiveRecord::Migration[6.1]
  def change
    create_table :rulesets do |t|
      t.string :name, null: false, comment: "Ruleset name"
      t.string :description, comment: "Description"
      t.integer :starting_man, null: false, comment: "Company starting manpower"
      t.integer :starting_mun, null: false, comment: "Company starting muntions"
      t.integer :starting_fuel, null: false, comment: "Company starting fuel"

      t.timestamps
    end
  end
end
