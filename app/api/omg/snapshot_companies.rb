module OMG
  class SnapshotCompanies < Grape::API
    helpers OMG::Helpers::RequestHelpers
    helpers OMG::Helpers::CompanyHelpers

    resource :snapshot_companies do

      namespace :owned do
        before do
          authenticate!
        end

        desc "retrieve player's snapshot companies"
        get do
          snapshots = SnapshotCompany.where(player: current_player)
          present snapshots
        end

        desc "create a snapshot company"
        params do
          requires :name, type: String, desc: "Name for the Snapshot Company"
          requires :sourceCompanyId, type: Integer, desc: "Source company id"
        end
        post do
          declared_params = declared(params)
          new_snapshot = Snapshot::Creator.new(current_player, declared_params[:name], declared_params[:sourceCompanyId]).create
          present new_snapshot
        end

        route_param :id, type: Integer do
          desc "delete a snapshot company"
          delete do
            Snapshot::Deleter.new(current_player, params[:id]).delete
          end
        end
      end

      route_param :uuid, type: String do
        desc "get snapshot company by uuid"
        params do
          requires :uuid, type: String, desc: "Snapshot Company uuid"
        end
        get do
          company = load_snapshot_company(params[:uuid])
          if company.blank?
            error! "Could not find company #{params[:uuid]}", 404
          end
          present company
        end

        desc 'Retrieve all squads, company offmaps, available units, available offmaps for the company'
        params do
          requires :uuid, type: String, desc: "Snapshot Company uuid"
        end
        get 'squads' do
          declared_params = declared(params)
          company = load_snapshot_company_squads(declared_params[:uuid])
          if company.blank?
            error! "Could not find company #{params[:uid]}", 404
          end

          company_resource_bonuses = CompanyBonusesService.get_snapshot_company_resource_bonuses(declared_params[:uuid])

          squads_response = {
            squads: company.squads,
            available_units: company.available_units,
            company_offmaps: company.company_offmaps,
            available_offmaps: company.available_offmaps,
            callin_modifiers: company.callin_modifiers,
            squad_upgrades: company.squad_upgrades,
            available_upgrades: company.available_upgrades,
            upgrades: company.upgrades,
            company_resource_bonuses: company_resource_bonuses
          }
          present squads_response, with: Entities::SquadsResponse, type: :include_unit
        end
      end

    end
  end
end
