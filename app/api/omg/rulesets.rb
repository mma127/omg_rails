module OMG
  class Rulesets < Grape::API
    helpers OMG::Helpers::RequestHelpers

    resource :rulesets do
      desc "get all rulesets"
      params do
        optional :type, type: String, default: Ruleset.ruleset_types[:war], values: Ruleset.ruleset_types.values, desc: "Ruleset type"
      end
      get do
        declared_params = declared(params)
        present Ruleset.where(ruleset_type: declared_params[:type]).order(id: :desc)
      end

      desc "get active ruleset"
      params do
        optional :type, type: String, default: Ruleset.ruleset_types[:war], values: Ruleset.ruleset_types.values, desc: "Ruleset type"
      end
      get :active do
        declared_params = declared(params)
        present Ruleset.find_by!(ruleset_type: declared_params[:type], is_active: true)
      end
    end
  end
end
