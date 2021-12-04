module Api
  module V1
    class SteamController < DeviseTokenAuth::OmniauthCallbacksController
      skip_before_action :verify_authenticity_token

      def steam
        @player = Player.from_omniauth(request.env["omniauth.auth"])

        sign_in_and_redirect @player
      end

      def failure
        render status: :unauthorized, json: { error: "You are not authorized to access this resource." }
      end
    end
  end
end
