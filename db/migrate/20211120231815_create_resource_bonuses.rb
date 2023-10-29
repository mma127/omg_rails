class CreateResourceBonuses < ActiveRecord::Migration[6.1]
  def change
    create_table :resource_bonuses do |t|
      t.string :name, null: false, comment: "Resource bonus name"
      t.string :resource, null: false, comment: "Resource type"
      t.integer :gained, default: 0, null: false, comment: "Bonus amount"
      t.integer :man_lost, default: 0, null: false, comment: "Man deducted"
      t.integer :mun_lost, default: 0, null: false, comment: "Mun deducted"
      t.integer :fuel_lost, default: 0, null: false, comment: "Fuel deducted"

      t.timestamps
    end
  end
end
