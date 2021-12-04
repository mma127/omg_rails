module Api
  module V1
    class PlayerController < ApplicationController
      def index
        render json: current_player.serializable_hash(only: [:id, :name, :avatar])
      end
    end
  end
end
