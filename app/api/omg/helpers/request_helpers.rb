module OMG
  module Helpers
    module RequestHelpers
      extend Grape::API::Helpers

      def declared_params
        @declared_params = declared(params)
      end

      def current_player
        warden = env["warden"]
        @current_player ||= warden.authenticate
      end

      def authenticate!
        error!("401 Unauthorized", 401) unless current_player
        current_player.try :touch # Update player updated_at for online list
      end
    end
  end
end
