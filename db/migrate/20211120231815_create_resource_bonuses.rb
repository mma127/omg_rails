class CreateResourceBonuses < ActiveRecord::Migration[6.1]
  def change
    create_table :resource_bonuses do |t|
      t.string :name, null: false, comment: "Resource bonus name"
      t.string :resource, null: false, comment: "Resource type"
      t.integer :man, default: 0, null: false, comment: "Man change"
      t.integer :mun, default: 0, null: false, comment: "Mun change"
      t.integer :fuel, default: 0, null: false, comment: "Fuel change"

      t.timestamps
    end

    add_index :resource_bonuses, :resource, :unique => true
  end
end
