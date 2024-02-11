class CompanyBonusesService
  class CompanyBonusesError < StandardError; end

  def initialize(company_id, player)
    @company_id = company_id
    @player = player
  end

  def self.get_snapshot_company_resource_bonuses(company_uuid)
    company = SnapshotCompany.includes(:ruleset, :company_resource_bonuses).find_by(uuid: company_uuid)
    self.build_company_resource_bonuses_response(company)
  end

  def get_company_resource_bonuses
    company = Company.includes(:ruleset, :company_resource_bonuses).find_by(id: @company_id, player: @player)
    CompanyBonusesService.build_company_resource_bonuses_response(company)
  end

  def purchase_resource_bonus(resource)
    company = ActiveCompany.includes(:ruleset, company_resource_bonuses: :resource_bonus).find_by(id: @company_id, player: @player)

    # Validate company belongs to player
    validate_can_update_company(company)

    # Validate company is not in battle
    validate_company_not_in_battle(company)

    # Validate company has fewer than max resource bonuses
    validate_can_add_resource_bonus(company)

    # Add a resource bonus to the company
    CompanyResourceBonus.create!(company: company, resource_bonus: ResourceBonus.find_by(resource: resource))

    # Update Company resources
    company_service = CompanyService.new(@player)
    company_service.recalculate_and_update_resources(company.reload, force_update = true) # Force the resources to update even if negative amounts
    CompanyBonusesService.build_company_resource_bonuses_response(company)
  end

  def refund_resource_bonus(resource)
    company = ActiveCompany.includes(:ruleset, company_resource_bonuses: :resource_bonus).find_by(id: @company_id, player: @player)

    # Validate company belongs to player
    validate_can_update_company(company)

    # Validate company is not in battle
    validate_company_not_in_battle(company)

    # Validate company has at least one of the requested type of resource
    resource_bonus = ResourceBonus.find_by(resource: resource)
    validate_can_refund_resource_bonus(company, resource_bonus)

    # Remove a CompanyResourceBonus of the requested type
    company.company_resource_bonuses.find_by(resource_bonus: resource_bonus).destroy!

    # Update Company resources
    company_service = CompanyService.new(@player)
    company_service.recalculate_and_update_resources(company.reload, force_update = true) # Force the resources to update even if negative amounts
    CompanyBonusesService.build_company_resource_bonuses_response(company)
  end

  private

  def self.build_company_resource_bonuses_response(company)
    company_bonuses = company.company_resource_bonuses
    ruleset = company.ruleset
    resource_bonuses = ResourceBonus.all
    man_rb = resource_bonuses.find { |rb| rb.resource == ResourceBonus.resources[:man] }
    mun_rb = resource_bonuses.find { |rb| rb.resource == ResourceBonus.resources[:mun] }
    fuel_rb = resource_bonuses.find { |rb| rb.resource == ResourceBonus.resources[:fuel] }

    {
      man_resource_bonus: man_rb,
      mun_resource_bonus: mun_rb,
      fuel_resource_bonus: fuel_rb,
      man_bonus_count: get_co_bonus_count_for_bonus(man_rb, company_bonuses),
      mun_bonus_count: get_co_bonus_count_for_bonus(mun_rb, company_bonuses),
      fuel_bonus_count: get_co_bonus_count_for_bonus(fuel_rb, company_bonuses),
      current_man: company.man,
      current_mun: company.mun,
      current_fuel: company.fuel,
      max_resource_bonuses: ruleset.max_resource_bonuses
    }
  end

  def self.get_co_bonus_count_for_bonus(resource_bonus, company_bonuses)
    company_bonuses.select { |cb| cb.resource_bonus == resource_bonus }.count
  end

  def validate_can_update_company(company)
    unless company.player == @player
      raise CompanyBonusesError.new("Player #{@player.id} cannot update Company #{company.id}")
    end
  end

  def validate_company_not_in_battle(company)
    if company.active_battle_id.present?
      raise CompanyBonusesError.new("Company #{company.id} is in an active battle and cannot be updated")
    end
  end

  def validate_can_add_resource_bonus(company)
    unless company.company_resource_bonuses.count < company.ruleset.max_resource_bonuses
      raise CompanyBonusesError.new("Company #{company.id} cannot add more resource bonuses")
    end
  end

  def validate_can_refund_resource_bonus(company, resource_bonus)
    unless company.company_resource_bonuses.where(resource_bonus: resource_bonus).present?
      raise CompanyBonusesError.new("Company #{company.id} cannot refund resource bonus of type #{resource_bonus.resource}, none exist.")
    end
  end
end
