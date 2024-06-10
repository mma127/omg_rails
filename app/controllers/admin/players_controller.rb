module Admin
  class PlayersController < AdminController
    before_action :set_player, only: %i[show edit update destroy]

    def index
      @players = Player.includes(:player_rating).order(:name)
    end

    def show

    end

    def edit

    end

    def update
      service = Admin::PlayerService.new(@player)
      if service.update(player_params, player_rating_params)
        respond_to do |format|
          format.html { redirect_to admin_players_path, notice: "Player was successfully updated." }
          format.turbo_stream { flash.now[:notice] = "Player was successfully updated." }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_player
      @player = Player.includes(:player_rating).find(params[:id])
    end

    def player_params
      params.require(:player).permit(:discord_id)
    end

    def player_rating_params
      params.require(:player_rating).permit(:elo_override)
    end
  end
end