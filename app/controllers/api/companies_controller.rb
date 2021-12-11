module Api
  class CompaniesController < ApiController
    before_action :authenticate_player!

    def index
      player_id = current_player.id
      companies = Company.where(player_id: player_id)
      render json: companies
    end

    def create
      doctrine = Doctrine.find(create_params[:doctrineId])
      Company.create!(name: create_params[:name],
                       player: current_player,
                       doctrine: doctrine,
                       faction: doctrine.faction)
    end

    private

    def create_params
      params.permit(:name, :doctrineId)
    end
  end
end
