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
require "rails_helper"

RSpec.describe ChatMessage, type: :model do
  let!(:chat_message) { create :chat_message }

  describe 'associations' do
    it { should belong_to(:chat) }
    it { should belong_to(:sender) }
  end
end
