class ChatService < ApplicationService
  def self.fetch_recent_messages(chat_name, limit)
    chat = Chat.find_by!(name: chat_name)
    ChatMessage.from(
      ChatMessage.where(chat: chat).order(id: :desc).limit(limit),
      :chat_messages
    ).order(:id)
  end

  def self.create_message(chat_name, sender_id, content)
    ChatMessageEmitterJob.perform_async(chat_name, sender_id, content)
  end

  def self.broadcast_cable(chat_message)
    ActionCable.server.broadcast LobbyChatChannel::CHANNEL, chat_message
  end
end
