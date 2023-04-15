class CompanyCallinModifierService
  def initialize(company)
    @company = company
  end

  def create_company_callin_modifiers(enabled_callin_modifiers)
    enabled_callin_modifiers.each do |ecm|
      CompanyCallinModifier.create!(company: @company, callin_modifier: ecm.callin_modifier)
    end
  end

  def remove_callin_modifiers(callin_modifiers_to_remove)
    company_callin_modifiers = CompanyCallinModifier.where(company: @company, callin_modifier: callin_modifiers_to_remove)
    company_callin_modifiers.destroy_all
  end
end
