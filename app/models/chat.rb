# == Schema Information
#
# Table name: chats
#
#  id                   :bigint           not null, primary key
#  name(chat room name) :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Chat < ApplicationRecord
  has_many :chat_messages, inverse_of: :chat
end
