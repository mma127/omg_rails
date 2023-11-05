module OMG
  class CompanyBonuses < Grape::API
    helpers OMG::Helpers::RequestHelpers

    before do
      authenticate!
    end

    resource :bonuses do
      desc "get all company bonuses"
      get do
        service = CompanyBonusesService.new(params[:id], current_player)
        present service.get_company_resource_bonuses, with: Entities::CompanyResourceBonuses
      end

      desc "purchase a resource bonus"
      params do
        requires :resource, type: String, desc: "Resource type to purchase"
      end
      post :purchase do
        declared_params = declared(params)
        service = CompanyBonusesService.new(params[:id], current_player)
        service.purchase_resource_bonus(declared_params[:resource])
      end
    end
  end
end
