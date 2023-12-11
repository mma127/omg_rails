module OMG
  class Companies < Grape::API
    helpers OMG::Helpers::RequestHelpers
    helpers OMG::Helpers::CompanyHelpers

    before do
      authenticate!
    end

    resource :companies do
      desc 'get all companies for the player'
      get do
        present Company.includes(:company_stats).where(player: current_player), type: :with_stats
      end

      desc 'create new company for the player'
      params do
        requires :doctrineId, type: Integer, as: :doctrine_id, desc: "Doctrine ID"
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
          Rails.logger.warn("Failed to create company for Player #{current_player.id} with params #{params}: #{e.message}\n#{e.backtrace.first(15).join("\n")}")
          error! e.message, 400
        end
      end

      route_param :id, type: Integer do
        desc "get details for the given company"
        params do
          requires :id, type: Integer, desc: "Company ID"
        end
        get do
          company = Company.includes(:available_units, :squads, :battle_players, :company_unlocks).find_by(id: params[:id], player: current_player)
          if company.blank?
            error! "Could not find company #{params[:id]} for the current player", 404
          end
          present company
        end

        # might not need this, combine with retrieve squads
        desc "get all available units, offmaps for the given company"
        params do
          requires :id, type: Integer, desc: "Company ID"
        end
        get 'availability' do
          company = Company.includes(available_units: :unit, available_offmaps: :offmap).find_by(id: params[:id], player: current_player)
          if company.blank?
            error! "Could not find company #{params[:id]} for the current player", 404
          end
          availability = {
            available_units: company.available_units,
            available_offmaps: company.available_offmaps
          }
          present availability, with: Entities::Availability, type: :include_unit
        end

        desc 'Retrieve all squads, company offmaps, available units, available offmaps for the company'
        params do
          requires :id, type: Integer, desc: "Company ID"
        end
        get 'squads' do
          declared_params = declared(params)
          company = load_company(declared_params[:id], current_player)
          if company.blank?
            error! "Could not find company #{params[:id]} for the current player", 404
          end

          squads_response = {
            squads: company.squads,
            available_units: company.available_units,
            company_offmaps: company.company_offmaps,
            available_offmaps: company.available_offmaps,
            callin_modifiers: company.callin_modifiers,
            squad_upgrades: company.squad_upgrades,
            available_upgrades: company.available_upgrades,
            upgrades: company.upgrades
          }
          present squads_response, with: Entities::SquadsResponse, type: :include_unit
        end

        desc 'Save squads for the company and update available units'
        params do
          requires :id, type: Integer, desc: "Company ID"
          group :squads, type: Array, desc: "Company squads list" do
            optional :id, type: Integer, as: :squad_id, desc: "Squad id, if exists. Empty for new squads"
            requires :unitId, type: Integer, as: :unit_id, desc: "Squad's unit id"
            requires :availableUnitId, type: Integer, as: :available_unit_id, desc: "Squad's available unit id"
            optional :name, type: String, desc: "Squad's name"
            requires :vet, type: BigDecimal, desc: "Squad veterancy"
            requires :tab, type: String, values: Squad.tab_categories.values, desc: "Squad's tab category"
            requires :index, type: Integer, desc: "Squad's position within a tab category"
            requires :uuid, type: String, desc: "Squad uuid"
            optional :totalModelCount, type: Integer, desc: "Total model count of this squad, if applicable"
            optional :transportedSquadUuids, type: Array, desc: "Optional list of uuids of squads this squad is transporting"
            optional :transportUuid, type: String, desc: "Optional uuid of the transport squad this squad is embarked in"
          end
          group :offmaps, type: Array, desc: "Company offmaps list" do
            optional :id, type: Integer, as: :company_offmap_id, desc: "Company offmap id"
            requires :availableOffmapId, type: Integer, as: :available_offmap_id, desc: "Available offmap id"
          end
          group :squadUpgrades, type: Array, desc: "Squad upgrades list" do
            optional :id, type: Integer, as: :squad_upgrade_id, desc: "Squad upgrade id"
            requires :availableUpgradeId, type: Integer, as: :available_upgrade_id, desc: "Available upgrade id"
            optional :squadId, type: Integer, as: :squad_id, desc: "Existing squad id"
            requires :squadUuid, type: String, as: :squad_uuid, desc: "Squad uuid"
          end
        end
        post 'squads' do
          begin
            declared_params = declared(params)
            company = Company.includes(:ruleset, :available_units,
                                       { squads: { squad_upgrades: :upgrade },
                                         available_upgrades: :upgrade,
                                         available_offmaps: :offmap,
                                         company_offmaps: :offmap })
                             .find_by(id: declared_params[:id], player: current_player)
            company_service = CompanyService.new(current_player)
            company_service.update_company_squads(company,
                                                  declared_params[:squads],
                                                  declared_params[:offmaps],
                                                  declared_params[:squadUpgrades])

            company = load_company(declared_params[:id], current_player)
            squads_response = { squads: company.squads, available_units: company.available_units,
                                company_offmaps: company.company_offmaps, available_offmaps: company.available_offmaps,
                                squad_upgrades: company.squad_upgrades, available_upgrades: company.available_upgrades,
                                upgrades: company.upgrades }
            present squads_response, with: Entities::SquadsResponse, type: :include_unit
          rescue StandardError => e
            Rails.logger.warn("Failed to upsert company squads/offmaps/squad upgrades for Player #{current_player.id}: #{e.message}\nParams #{declared_params}\nBacktrace: #{e.backtrace.first(15).join("\n")}")
            error! e.message, 400
          end
        end

        desc "delete the given company"
        params do
          requires :id, type: Integer, desc: "Company ID"
        end
        delete do
          company = Company.find_by(id: params[:id], player: current_player)
          if company.blank?
            error! "Could not find company #{params[:id]} for the current player", 404
          end

          company_service = CompanyService.new(current_player)
          company_service.delete_company(company)

          params[:id]
        end

        mount CompanyUnlocks
        mount CompanyBonuses
      end
    end
  end
end


