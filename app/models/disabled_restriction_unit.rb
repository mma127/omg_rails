class DisabledRestrictionUnit < RestrictionUnit
  before_save :generate_description

  private

  def generate_description
    self.description = "#{restriction.name} - #{unit.display_name} - DISABLED"
  end
end
