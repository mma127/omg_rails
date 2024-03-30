class CreateUnlocks < ActiveRecord::Migration[6.1]
  def change
    create_table :unlocks, comment: "Metadata for a generic doctrine ability" do |t|
      t.string :name, null: false, comment: "Unlock internal name"
      t.string :display_name, null: false, comment: "Unlock display name"
      t.string :const_name, comment: "Const name of the doctrine ability for the battle file"
      t.text :description, comment: "Display description of this doctrine ability"
      t.string :image_path, comment: "Url to the image to show for this doctrine ability"
      t.references :ruleset, index: true, foreign_key: true, null: false

      t.timestamps
    end

    add_index :unlocks, :name, unique: true
  end
end
