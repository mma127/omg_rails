module Api
  class CompaniesController < ApiController
    before_action :authenticate_player!

    def index
      player_id = params[:id]
      if player_id.present?
        companies = Company.where(player_id: player_id)
      else
        companies = Company.all
      end
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
