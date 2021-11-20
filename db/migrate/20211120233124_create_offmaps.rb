class CreateOffmaps < ActiveRecord::Migration[6.1]
  def change
    create_table :offmaps do |t|
      t.string :name, comment: "Offmap name"
      t.string :const_name, comment: "Offmap const name for battlefile"
      t.references :restriction, index: true, foreign_key: true
      t.integer :mun, comment: "Munitions cost"
      t.integer :max, comment: "Maximum number purchasable"

      t.timestamps
    end
  end
end
