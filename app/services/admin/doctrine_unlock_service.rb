module Admin
  class DoctrineUnlockService < ApplicationService
    def self.disable_doctrine_unlock(doctrine_unlock)
      # Refund all companies that have purchased this doctrine unlock
      CompanyUnlock.includes(:company).where(doctrine_unlock: doctrine_unlock).each do |cu|
        service = CompanyUnlockService.new(cu.company)
        service.refund_company_unlock(cu.id)
      end

      # Mark this doctrine unlock as disabled
      doctrine_unlock.update!(disabled: true)
    end
  end
end
