module Admin
  class PlayerService < ApplicationService
    def initialize(player)
      @player = player
    end

    def update(player_params, player_rating_params)
      # Wrap this in transaction, group up errors, return boolean for success or failure

      ActiveRecord::Base.transaction do
        override_elo = player_rating_params[:elo_override] || nil
        @player.player_rating.update!(elo_override: override_elo)
        @player.update!(player_params)
      end
    end
  end
end