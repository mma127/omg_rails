require "rails_helper"

RSpec.describe DisabledRestrictionUnit, type: :model do

  it "generates and saves the description" do
    unit = create :infantry, display_name: "Rifles"
    restriction = create :restriction, name: "American army"
    ruleset = create :ruleset
    base_restriction_unit = create :disabled_restriction_unit, restriction: restriction, unit: unit, ruleset: ruleset
    expect(base_restriction_unit.description).to eq("American army - Rifles - DISABLED")
  end
end