module OMG
  class Restrictions < Grape::API
    helpers OMG::Helpers::RequestHelpers

    resource :restrictions do
      namespace :units do
        desc "get all unit restrictions for the ruleset and filters"
        params do
          requires :rulesetId, type: Integer, as: :ruleset_id, desc: "Ruleset id"
          requires :factionId, type: Integer, as: :faction_id, desc: "Faction id"
          optional :doctrineId, type: Integer, as: :doctrine_id, desc: "Doctrine id"
        end
        get do
          declared_params = declared(params)
          service = RestrictionUnitsService.new(declared_params[:ruleset_id], declared_params[:faction_id], declared_params[:doctrine_id])
          present service.get_restriction_units, with: Entities::RestrictionUnitsResult, type: :include_restriction
        end
      end

      namespace :upgrades do
        desc "get all upgrade restrictions for the ruleset and filters"
        params do
          requires :rulesetId, type: Integer, as: :ruleset_id, desc: "Ruleset id"
          requires :factionId, type: Integer, as: :faction_id, desc: "Faction id"
          optional :doctrineId, type: Integer, as: :doctrine_id, desc: "Doctrine id"
        end
        get do
          declared_params = declared(params)
          service = RestrictionUpgradesService.new(declared_params[:ruleset_id], declared_params[:faction_id], declared_params[:doctrine_id])
          present service.get_restriction_upgrades, with: Entities::RestrictionUpgradesResult, type: :include_restriction
        end
      end

      namespace :offmaps do
        # TODO
      end
    end
  end
end
