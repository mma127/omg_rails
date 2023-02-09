class CreateDoctrineUnlocks < ActiveRecord::Migration[6.1]
  def change
    create_table :doctrine_unlocks, comment: "Associates doctrines to unlocks" do |t|
      t.references :doctrine, index: true, foreign_key: true
      t.references :unlock, index: true, foreign_key: true
      t.string :internal_description, comment: "Doctrine and Unlock names"
      t.integer :vp_cost, default: 0, null: false, comment: "VP cost of this doctrine unlock"
      t.integer :tree, comment: "Which tree of the doctrine this unlock will appear at"
      t.integer :branch, comment: "Which branch of the doctrine tree this unlock will appear at"
      t.integer :row, comment: "Which row of the doctrine tree branch this unlock will appear at"

      t.timestamps
    end

    add_index :doctrine_unlocks, [:doctrine_id, :unlock_id], unique: true
    add_index :doctrine_unlocks, [:doctrine_id, :tree, :branch, :row], unique: true, name: "index_doctrine_unlocks_on_doctrine_tree"
  end
end
