# == Schema Information
#
# Table name: chat_messages
#
#  id                            :bigint           not null, primary key
#  content(chat message content) :text
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  chat_id                       :bigint
#  sender_id                     :bigint           not null
#
# Indexes
#
#  index_chat_messages_on_chat_id    (chat_id)
#  index_chat_messages_on_sender_id  (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (sender_id => players.id)
#
class ChatMessage < ApplicationRecord
  belongs_to :chat
  belongs_to :sender, class_name: "Player"
end
