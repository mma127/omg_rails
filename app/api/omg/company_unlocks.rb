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

      desc 'purchase a doctrine unlock'
      params do
        requires :doctrineUnlockId, type: Integer, desc: "Doctrine unlock to purchase for the company"
      end
      post 'purchase' do
        declared_params = declared(params)
        company = Company.includes(:company_unlocks, :squads, :ruleset, :available_units).find_by(id: declared_params[:id], player: current_player)
        doctrine_unlock = DoctrineUnlock.includes(:unlock).find(declared_params[:doctrineUnlockId])
        service = CompanyUnlockService.new(company)
        service.purchase_doctrine_unlock(doctrine_unlock)

        present doctrine_unlock
      end

      desc 'refund a doctrine unlock'
      params do
        requires :companyUnlockId, type: Integer, desc: "Company unlock to refund"
      end
      post 'refund' do
        declared_params = declared(params)
        company = Company.includes(:company_unlocks, :squads, :ruleset, :available_units).find_by(id: declared_params[:id], player: current_player)
        company_unlock = CompanyUnlock.find(declared_params[:companyUnlockId])
        service = CompanyUnlockService.new(company)
        service.refund_company_unlock(declared_params[:companyUnlockId])

        present company_unlock
      end
    end
  end
end
