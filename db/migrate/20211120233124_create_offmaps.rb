class CreateOffmaps < ActiveRecord::Migration[6.1]
  def change
    create_table :offmaps do |t|
      t.string :name, comment: "Offmap name"
      t.string :display_name, comment: "Offmap display name"
      t.string :const_name, comment: "Offmap const name for battlefile"
      t.string :description, comment: "Offmap description"

      t.timestamps
    end
  end
end
