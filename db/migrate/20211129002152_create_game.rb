class CreateGame < ActiveRecord::Migration[6.1]
  def change
    create_table :games, comment: "Metadata for CoH games, including alpha" do |t|
      t.string :name, comment: "Game name"

      t.timestamps
    end
  end
end
