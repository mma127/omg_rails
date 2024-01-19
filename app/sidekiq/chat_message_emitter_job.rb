class  ChatMessageEmitterJob
  include Sidekiq::Job

  def perform(chat_name, sender_id, content)
    chat = Chat.find_by(name: chat_name)
    chat_message = ChatMessage.create!(chat: chat, sender_id: sender_id, content: content)
    # Broadcast to chat
    ChatService.broadcast_cable(ChatMessage::Entity.represent chat_message)
  end
end