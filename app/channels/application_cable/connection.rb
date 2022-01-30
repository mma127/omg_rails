module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = find_user
    end

    protected

    def find_user
      begin
        return Player.find(cookies.encrypted['_omg_rails_session']['warden.user.player.key'][0][0])
      rescue StandardError => e
        nil
      end
      # reject_unauthorized_connection
    end
  end
end
