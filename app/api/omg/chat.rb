module OMG
  class Chat < Grape::API
    helpers OMG::Helpers::RequestHelpers

    resource :chat do
      route_param :chat_name do
        desc "get messages for a chat"
        params do
          optional :limit, type: Integer, default: 30, desc: "number of recent messages to retrieve"
        end
        get do
          declared_params = declared(params)
          present ChatService.fetch_recent_messages(params[:chat_name], declared_params[:limit])
        end
        
        desc "Save a message for a chat"
        params do
          requires :senderId, type: Integer, desc: "Chat message sender id"
          requires :content, type: String, desc: "Chat message content"
        end
        post do
          declared_params = declared(params)
          ChatService.create_message(params[:chat_name], declared_params[:senderId], declared_params[:content])
        end
      end
    end
  end
end
