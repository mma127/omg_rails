module Api
  class CompaniesController < ApiController
    before_action :authenticate_player!

    def index
      player_id = current_player.id
      companies = Company.where(player_id: player_id)
      render json: CompanySerializer.new(companies).serializable_hash
    end

    def create
      # For allies, get doctrine, validate is an allied doctrine
      allies = create_params[:allies]
      allied_doctrine = Doctrine.find(allies[:doctrineId])
      if allied_doctrine.faction.side != Faction.sides[:allies]
        render json: "Invalid doctrine #{allied_doctrine.name} for an allied company", status: :bad_request
      end
      axis = create_params[:axis]
      axis_doctrine = Doctrine.find(axis[:doctrineId])
      if axis_doctrine.faction.side != Faction.sides[:axis]
        render json: "Invalid doctrine #{axis_doctrine.name} for an axis company", status: :bad_request
      end


      new_allied = Company.create!(name: allies[:name],
                       player: current_player,
                       doctrine: allied_doctrine,
                       faction: allied_doctrine.faction)

      new_axis = Company.create!(name: axis[:name],
                       player: current_player,
                       doctrine: axis_doctrine,
                       faction: axis_doctrine.faction)
      render json: CompanySerializer.new([new_allied, new_axis]).serializable_hash, status: :created, serializer: ApplicationSerializer
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
      params.permit(allies: [:name, :doctrineId], axis: [:name, :doctrineId])
    end
  end
end
