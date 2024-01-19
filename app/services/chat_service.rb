class ChatService < ApplicationService
  def self.fetch_recent_messages(chat_name, limit)
    chat = Chat.find_by!(name: chat_name)
    ChatMessage.where(chat: chat).order(created_at: :asc).limit(limit)
  end

  def self.create_message(chat_name, sender_id, content)
    ChatMessageEmitterJob.perform_async(chat_name, sender_id, content)
  end

  def self.broadcast_cable(chat_message)
    ActionCable.server.broadcast LobbyChatChannel::CHANNEL, chat_message
  end
end
