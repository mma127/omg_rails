class PlayerController < ApplicationController
  include Tokenable::Authable
  before_action :require_tokenable_user!

  def index
  render json: current_user.serializable_hash(only: [:id, :name, :avatar])
  end
end
