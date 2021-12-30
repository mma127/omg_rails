# == Schema Information
#
# Table name: restriction_units
#
#  id                                                                                    :bigint           not null, primary key
#  callin_modifier(Base callin modifier, default is 1)                                   :decimal(, )      default(1.0)
#  company_max(Maximum number of the unit a company can hold)                            :integer
#  description(What does this RestrictionUnit do?)                                       :string
#  fuel(Fuel cost)                                                                       :integer
#  man(Manpower cost)                                                                    :integer
#  mun(Munition cost)                                                                    :integer
#  pop(Population cost)                                                                  :decimal(, )
#  priority(Priority order to apply the modification from 1 -> 100)                      :integer
#  resupply(Per game resupply)                                                           :integer
#  resupply_max(How much resupply is available from saved up resupplies, <= company max) :integer
#  type(What effect this restriction has on the unit)                                    :string           not null
#  created_at                                                                            :datetime         not null
#  updated_at                                                                            :datetime         not null
#  restriction_id                                                                        :bigint
#  unit_id                                                                               :bigint
#
# Indexes
#
#  index_restriction_units_on_restriction_id              (restriction_id)
#  index_restriction_units_on_restriction_id_and_unit_id  (restriction_id,unit_id) UNIQUE
#  index_restriction_units_on_unit_id                     (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (unit_id => units.id)
#
require "rails_helper"

RSpec.describe BaseRestrictionUnit, type: :model do
  it "generates and saves the description" do
    unit = create :infantry, display_name: "Rifles"
    restriction = create :restriction, name: "American army"
    base_restriction_unit = create :base_restriction_unit, restriction: restriction, unit: unit
    expect(base_restriction_unit.description).to eq("American army - Rifles")
  end
end


