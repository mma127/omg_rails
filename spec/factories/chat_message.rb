FactoryBot.define do
  factory :chat_message do
    association :chat
    association :sender, factory: :player
    content { "chat message content" }
  end
end