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
        requires :doctrineId, type: Integer,  as: :doctrine_id, desc: "Doctrine ID"
        requires :name, type: String, desc: "Company name"
      end
      post do
        begin
          declared_params = declared(params)
          doctrine = Doctrine.find_by(id: declared_params[:doctrine_id])
          company_service = CompanyService.new(current_player)
          new_company = company_service.create_company(doctrine, declared_params[:name])

          present new_company
        rescue StandardError => e
          Rails.logger.warn("Failed to create company for Player #{current_player.id} with params #{params}: #{e.message}")
          error! e.message, 400
        end
      end

      desc "get details for the given company"
      params do
        requires :id, type: Integer, desc: "Company ID"
      end
      get ':id' do
        company = Company.includes(:available_units, :squads).find_by(id: params[:id], player: current_player)
        if company.blank?
          error! "Could not find company #{params[:id]} for the current player", 404
        end
        present company, type: :full
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

      desc 'Save squads for the player and update available units'
      params do
        requires :id, type: Integer, desc: "Company ID"
        group :squads, type: Array, desc: "Company squads list" do
          optional :squadId, type: Integer, as: :squad_id, desc: "Squad id, if exists. Empty for new squads"
          requires :unitId, type: Integer, as: :unit_id, desc: "Squad's unit id"
          optional :name, type: String, desc: "Squad's name"
          requires :vet, type: BigDecimal, desc: "Squad veterancy"
          requires :tab, type: String, values: Squad.tab_categories.values, desc: "Squad's tab category"
          requires :index, type: Integer, desc: "Squad's position within a tab category"
        end
      end
      post ':id/squads' do
        begin
          declared_params = declared(params)
          company = Company.includes(:squads, :ruleset, :available_units).find_by(id: declared_params[:id], player: current_player)
          company_service = CompanyService.new(current_player)
          squads, available_units = company_service.update_company_squads(company, declared_params[:squads])

          squads_response = {squads: squads, available_units: available_units}
          present squads_response, with: Entities::SquadsResponse
        rescue StandardError => e
          Rails.logger.warn("Failed to create company for Player #{current_player.id}: #{e.message}\nParams #{declared_params}")
          error! e.message, 400
        end
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


