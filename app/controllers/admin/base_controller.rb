module Admin
  class BaseController < AdminController
    def index
      unless player_signed_in?
        redirect_to "/"
      end
    end
  end
end