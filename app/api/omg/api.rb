module OMG
  class API < Grape::API
    helpers OMG::Helpers

    format :json
    prefix :api

    # Format:
    # {
    #     "error": [
    #         "id is invalid"
    #     ]
    # }
    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error! e.full_messages, 400
    end

    rescue_from :all

    mount Players
    mount Doctrines
    mount Companies

    route :any, '*path' do
      error! "Not implemented", 404
    end
  end
end

