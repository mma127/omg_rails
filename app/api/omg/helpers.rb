module OMG
  module Helpers
    extend Grape::API::Helpers

    def current_player
      warden = env["warden"]
      @current_player ||= warden.authenticate
    end

    def authenticate!
      error!("401 Unauthorized", 401) unless current_player
    end
  end
end
