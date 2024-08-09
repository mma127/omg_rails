module Admin
  class UnitService < AdminService
    def initialize(ruleset)
      @ruleset = ruleset

      super
    end

    def disable(unit)
      # Update unit disabled to true
      unit.update!(disabled: true)

      # Squads in the ruleset using this unit that belong to ActiveCompanies
      affected_squads = Squad.joins(:available_unit, :company).where(available_unit: { unit_id: unit.id }, company: { type: ActiveCompany.name })

      # ActiveCompanies that those squads belong to
      # NOTE: We do not want to change SnapshotCompanies!
      affected_companies = ActiveCompany.where(id: affected_squads.map(&:company_id))

      # Destroy all squads including dependent associations
      affected_squads.destroy_all

      # Recalculate affected company resources
      affected_companies.each do |company|
        company_service = CompanyService.new(nil)
        company_service.recalculate_and_update_resources(company.reload)
      end
    end

    def enable(unit)
      unit.update!(disabled: false)
    end
  end
end
