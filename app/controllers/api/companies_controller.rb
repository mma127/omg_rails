module API
  class CompaniesController < APIController
    before_action :authenticate_player!

    def index
      player_id = current_player.id
      companies = Company.where(player_id: player_id)
      render json: CompanySerializer.new(companies).serializable_hash
    end

    def create
      if create_params[:doctrine_id].blank?
        render json: "Doctrine id is required", status: :bad_request
      end
      doctrine_id = create_params[:doctrine_id]
      doctrine = Doctrine.find_by(id: doctrine_id)
      if doctrine.blank?
        render json: "Invalid doctrine with id #{doctrine_id}", status: :bad_request
      end

      begin
        company_service = CompanyService.new(current_player)
        new_company = company_service.create_company(doctrine, create_params[:name])

        render json: CompanySerializer.new(new_company).serializable_hash, status: :created, serializer: ApplicationSerializer
      rescue StandardError => e
        Rails.logger.warn("Failed to create company for Player #{current_player.id} with params #{create_params}: #{e.message}")
        render json: e.message, status: :bad_request
      end
    end

    def available_units
      company = Company.find(params[:id])
      available_units = company.available_units

      render json: AvailableUnitsSerializer.new(available_units).serializable_hash
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
      params.permit(:name, :doctrine_id)
    end
  end
end
