module OMG
  class Stats < Grape::API
    helpers OMG::Helpers::RequestHelpers

    resource :stats do
      namespace :units do
        desc "Retrieve stats_unit for given unit const name and ruleset"
        params do
          requires :name, type: String, desc: "Unit unique name"
          requires :const_name, type: String, desc: "Unit (sbps) const name"
          requires :ruleset_id, type: Integer, desc: "Rule set ID"
        end
        get do
          declared_params = declared(params)
          stats_unit, stats_entities, stats_weapons, stats_weapons_upgrades = StatsUnitsService.fetch_for_const_name(declared_params[:name],
                                                                                                                     declared_params[:const_name],
                                                                                                                     declared_params[:ruleset_id])
          response = { stats_unit: stats_unit, stats_entities: stats_entities, stats_weapons: stats_weapons, stats_weapons_upgrades: stats_weapons_upgrades }
          present response, with: Entities::StatsUnitResponse
        end
      end

      namespace :weapons do
        desc "Retrieve stats_weapon for given weapon reference and ruleset"
        params do
          requires :reference, type: String, desc: "Weapon reference"
          requires :ruleset_id, type: Integer, desc: "Rule set ID"
        end
        get do
          declared_params = declared(params)
          present StatsWeaponsService.fetch_for_reference(declared_params[:reference],
                                                          declared_params[:ruleset_id])
        end
      end
    end
  end
end
