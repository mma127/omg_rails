require "omniauth/strategies/steam"
require "openid/store/filesystem"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :steam, ENV['STEAM_WEB_API_KEY'], :storage => OpenID::Store::Filesystem.new("/tmp")
end
