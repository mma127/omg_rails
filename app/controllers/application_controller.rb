class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # , if: :verify_api
  #
  # def authenticate_current_player
  #   head :unauthorized if current_player_get.nil?
  # end
  #
  # def current_player_get
  #   return nil unless cookies[:auth_headers]
  #   auth_headers = JSON.parse(cookies[:auth_headers])
  #   expiration_datetime = DateTime.strptime(auth_headers['expiry'], '%s')
  #   current_player = Player.find_by(uid: auth_headers['uid'])
  #
  #   if current_player &&
  #     current_player.tokens.key?(auth_headers['client']) &&
  #     expiration_datetime > DateTime.now
  #     @current_player = current_player
  #   end
  #
  #   @current_player
  # end
  #
  # def verify_api
  #   params[:controller].split('/')[0] != 'devise_token_auth'
  # end
  #
  # protected
  #
  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:uid, :provider])
  # end
end
