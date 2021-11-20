class CreateResourceBonuses < ActiveRecord::Migration[6.1]
  def change
    create_table :resource_bonuses do |t|
      t.string :name, comment: "Resource bonus name"
      t.string :type, comment: "Resource type"
      t.integer :value, comment: "Bonus amount"

      t.timestamps
    end
  end
end
