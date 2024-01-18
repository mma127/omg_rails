class CreateChatMessage < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_messages, comment: "messages for a chat room" do |t|
      t.references :chat, index: true, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :players }
      t.text :content, comment: "chat message content"

      t.timestamps
    end
  end
end
