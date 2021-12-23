module OMG
  class Companies < Grape::API
    helpers OMG::Helpers

    before do
      authenticate!
    end

    resource :companies do
      desc 'get all companies for the player'
      get do
        present Company.where(player: current_player)
      end

      desc 'create new company for the player'
      params do
        requires :doctrineId, type: Integer, desc: "Doctrine ID"
        requires :name, type: String, desc: "Company name"
      end
      post do
        begin
          doctrine = Doctrine.find_by(id: params[:doctrineId])
          company_service = CompanyService.new(current_player)
          new_company = company_service.create_company(doctrine, params[:name])

          present new_company
        rescue StandardError => e
          Rails.logger.warn("Failed to create company for Player #{current_player.id} with params #{params}: #{e.message}")
          error! e.message, 400
        end
      end

      desc "get all available units for the given company"
      params do
        requires :id, type: Integer, desc: "Company ID"
      end
      get ':id/available_units' do
        company = Company.find_by(id: params[:id], player: current_player)
        if company.blank?
          error! "Could not find company #{params[:id]} for the current player", 404
        end
        present company.available_units
      end

      desc "delete the given company"
      params do
        requires :id, type: Integer, desc: "Company ID"
      end
      delete ':id' do
        company = Company.find_by(id: params[:id], player: current_player)
        if company.blank?
          error! "Could not find company #{params[:id]} for the current player", 404
        end

        company_service = CompanyService.new(current_player)
        company_service.delete_company(company)

        params[:id]
      end
    end
  end
end


