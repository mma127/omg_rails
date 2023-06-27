class CreateUpgrades < ActiveRecord::Migration[6.1]
  def change
    create_table :upgrades do |t|
      t.string :const_name, comment: "Upgrade const name used by the battlefile"
      t.string :name, null: false, comment: "Unique upgrade name"
      t.string :display_name, null: false, comment: "Display upgrade name"
      t.string :description, comment: "Upgrade description"
      t.integer :model_count, comment: "How many model entities this unit replacement consists of"
      t.integer :additional_model_count, comment: "How many model entities this upgrade adds to the base unit"
      t.string :type, null: false, comment: "Type of Upgrade"

      t.timestamps
    end
  end
end
