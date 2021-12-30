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

    rescue_from :all do |e|
      Rails.logger.error("Error during Grape endpoint: #{e.message}\nBacktrace: #{e.backtrace.first(15).join("\n")}")
      error! e.message
    end

    mount Players
    mount Doctrines
    mount Companies
    mount Units

    route :any, '*path' do
      error! "Not implemented", 404
    end
  end
end

