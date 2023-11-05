class CompanyBonusesService
  def initialize(company_id, player)
    @company_id = company_id
    @player = player
  end

  def get_company_resource_bonuses
    company = Company.includes(:ruleset, :company_resource_bonuses).find_by(id: @company_id, player: @player)
    company_bonuses = company.company_resource_bonuses
    ruleset = company.ruleset
    resource_bonuses = ResourceBonus.all

    {
      resource_bonuses: resource_bonuses,
      man_bonus_count: get_co_bonus_count_for_bonus(resource_bonuses.find_by(resource: ResourceBonus::resources[:man]), company_bonuses),
      mun_bonus_count: get_co_bonus_count_for_bonus(resource_bonuses.find_by(resource: ResourceBonus::resources[:mun]), company_bonuses),
      fuel_bonus_count: get_co_bonus_count_for_bonus(resource_bonuses.find_by(resource: ResourceBonus::resources[:fuel]), company_bonuses),
      current_man: company.man,
      current_mun: company.mun,
      current_fuel: company.fuel,
      max_resource_bonuses: ruleset.max_resource_bonuses
    }
  end

  def purchase_resource_bonus(resource)
    # Validate company belongs to player
    # Validate company has fewer than max resource bonuses
    # Add a resource bonus to the company
    # Update Company resources
  end

  private

  def get_co_bonus_count_for_bonus(resource_bonus, company_bonuses)
    company_bonuses.where(resource_bonus_id: resource_bonus.id).count
  end
end
