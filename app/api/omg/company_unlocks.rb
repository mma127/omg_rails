module OMG
  class CompanyUnlocks < Grape::API
    helpers OMG::Helpers

    before do
      authenticate!
    end

    resource :unlocks do
      desc 'get all company unlocks'
      get do
        company_unlocks = CompanyUnlock.where(company_id: params[:id])
        present company_unlocks
      end
    end
  end
end
