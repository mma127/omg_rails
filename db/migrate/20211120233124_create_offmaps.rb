class CreateOffmaps < ActiveRecord::Migration[6.1]
  def change
    create_table :offmaps do |t|
      t.string :name, comment: "Offmap name"
      t.string :const_name, comment: "Offmap const name for battlefile"
      t.integer :mun, comment: "Munitions cost"

      t.timestamps
    end
  end
end
