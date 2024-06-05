class AdminController < ActionController::Base
  protect_from_forgery with: :exception
  layout "admin"

  before_action :authenticate_player!

  def index

  end
end
