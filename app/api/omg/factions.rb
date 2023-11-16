module OMG
  class Factions < Grape::API
    helpers OMG::Helpers::RequestHelpers

    resource :factions do
      desc 'get all factions'
      get do
        present Faction.all
      end

      route_param :id, type: Integer do
        desc 'get requested faction'
        params do
          requires :id, type: Integer, desc: "Faction ID"
        end
        get do
          present Faction.find(params[:id])
        end
      end
    end
  end
end

