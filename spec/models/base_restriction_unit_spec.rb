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
#  ruleset_id                                                                            :bigint           not null
#  unit_id                                                                               :bigint
#
# Indexes
#
#  index_restriction_units_on_restriction_id_and_ruleset_id  (restriction_id,ruleset_id)
#  index_restriction_units_on_ruleset_id                     (ruleset_id)
#  index_restriction_units_on_unit_id_and_ruleset_id         (unit_id,ruleset_id)
#  index_restriction_units_restriction_unit_ruleset          (restriction_id,unit_id,ruleset_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (unit_id => units.id)
#
require "rails_helper"

RSpec.describe BaseRestrictionUnit, type: :model do

  describe 'validations' do
    it { should validate_numericality_of(:man) }
    it { should validate_numericality_of(:mun) }
    it { should validate_numericality_of(:fuel) }
    it { should validate_numericality_of(:pop) }
    it { should validate_numericality_of(:callin_modifier) }
    it { should validate_numericality_of(:resupply) }
    it { should validate_numericality_of(:resupply_max) }
    it { should validate_numericality_of(:company_max) }
  end


  it "generates and saves the description" do
    unit = create :infantry, display_name: "Rifles"
    restriction = create :restriction, name: "American army"
    ruleset = create :ruleset
    base_restriction_unit = create :base_restriction_unit, restriction: restriction, unit: unit, ruleset: ruleset
    expect(base_restriction_unit.description).to eq("American army - Rifles")
  end
end


