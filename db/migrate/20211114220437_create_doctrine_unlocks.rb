class CreateDoctrineUnlocks < ActiveRecord::Migration[6.1]
  def change
    create_table :doctrine_unlocks, comment: "Associates doctrines to unlocks" do |t|
      t.references :doctrine, index: true, foreign_key: true
      t.references :unlock, index: true, foreign_key: true
      t.integer :tree, comment: "Which tree of the doctrine this unlock will appear at"
      t.integer :branch, comment: "Which branch of the doctrine tree this unlock will appear at"
      t.integer :row, comment: "Which row of the doctrine tree branch this unlock will appear at"

      t.timestamps
    end

    add_index :doctrine_unlocks, [:doctrine_id, :unlock_id], unique: true
    add_index :doctrine_unlocks, [:doctrine_id, :tree, :branch, :row], unique: true, name: "index_doctrine_unlocks_on_doctrine_tree"
  end
end
