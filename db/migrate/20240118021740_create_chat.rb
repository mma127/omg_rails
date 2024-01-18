class CreateChat < ActiveRecord::Migration[6.1]
  def change
    create_table :chats, comment: "chat rooms" do |t|
      t.string :name, null: false, comment: "chat room name"

      t.timestamps
    end

    add_index :chats, :name, unique: true
  end
end
