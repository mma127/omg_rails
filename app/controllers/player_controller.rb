class PlayerController < ApplicationController
  before_action :authenticate_player!

  def index
  render json: current_player.serializable_hash(only: [:id, :name, :avatar])
  end
end
