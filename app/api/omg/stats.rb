module OMG
  class Stats < Grape::API
    helpers OMG::Helpers::RequestHelpers

    resource :stats do
      namespace :units do
        desc "Retrieve stats_unit for given unit const name and ruleset"
        params do
          requires :const_name, type: String, desc: "Unit (sbps) const name"
          requires :ruleset_id, type: Integer, desc: "Rule set ID"
        end
        get do
          declared_params = declared(params)
          stats_unit, stats_entities, stats_weapons = StatsUnitsService.fetch_for_const_name(declared_params[:const_name],
                                                                                             declared_params[:ruleset_id])
          response = { stats_unit: stats_unit, stats_entities: stats_entities, stats_weapons: stats_weapons }
          present response, with: Entities::StatsUnitResponse
        end
      end
    end
  end
end
