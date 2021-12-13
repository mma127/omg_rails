module Api
  class CompaniesController < ApiController
    before_action :authenticate_player!

    def index
      player_id = current_player.id
      companies = Company.where(player_id: player_id)
      render json: CompanySerializer.new(companies).serializable_hash
    end

    def create
      if create_params[:doctrineId].blank?
        render json: "Doctrine id is required", status: :bad_request
      end
      doctrine = Doctrine.find_by(id: create_params[:doctrineId])
      if doctrine.blank?
        render json: "Invalid doctrine with id #{create_params[:doctrineId]}", status: :bad_request
      end

      new_company = Company.create!(name: create_params[:name],
                                     player: current_player,
                                     doctrine: doctrine,
                                     faction: doctrine.faction)
      render json: CompanySerializer.new(new_company).serializable_hash, status: :created, serializer: ApplicationSerializer
    end

    def destroy
      company_id = params[:id]
      company = Company.find_by(id: company_id, player: current_player)
      if company.blank?
        render json: "Failed to destroy company", status: :bad_request
      end
      company.destroy!
      render json: company_id
    end

    private

    def create_params
      params.permit(:name, :doctrineId)
    end
  end
end
