# == Schema Information
#
# Table name: restriction_units
#
#  id                                                                                    :bigint           not null, primary key
#  callin_modifier(Base callin modifier)                                                 :decimal(, )
#  company_max(Maximum number of the unit a company can hold)                            :integer
#  fuel(Fuel cost)                                                                       :integer
#  internal_description(What does this RestrictionUnit do?)                              :string           not null
#  man(Manpower cost)                                                                    :integer
#  mun(Munition cost)                                                                    :integer
#  pop(Population cost)                                                                  :decimal(, )
#  priority(Priority order to apply the modification from 1 -> 100)                      :integer
#  resupply(Per game resupply)                                                           :integer
#  resupply_max(How much resupply is available from saved up resupplies, <= company max) :integer
#  type(What effect this restriction has on the unit)                                    :string           not null
#  unitwide_upgrade_slots(Unit wide weapon replacement slot)                             :integer
#  upgrade_slots(Slots used for per model weapon upgrades)                               :integer
#  created_at                                                                            :datetime         not null
#  updated_at                                                                            :datetime         not null
#  restriction_id                                                                        :bigint
#  ruleset_id                                                                            :bigint
#  unit_id                                                                               :bigint
#
# Indexes
#
#  index_restriction_units_on_restriction_id                 (restriction_id)
#  index_restriction_units_on_restriction_id_and_ruleset_id  (restriction_id,ruleset_id)
#  index_restriction_units_on_ruleset_id                     (ruleset_id)
#  index_restriction_units_on_unit_id                        (unit_id)
#  index_restriction_units_on_unit_id_and_ruleset_id         (unit_id,ruleset_id)
#  index_restriction_units_restriction_unit_ruleset_type     (restriction_id,unit_id,ruleset_id,type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (ruleset_id => rulesets.id)
#  fk_rails_...  (unit_id => units.id)
#
require "rails_helper"

RSpec.describe EnabledUnit, type: :model do

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


  it "generates and saves the internal_description" do
    unit = create :infantry, display_name: "Rifles"
    restriction = create :restriction, name: "American army"
    ruleset = create :ruleset
    enabled_unit = create :enabled_unit, restriction: restriction, unit: unit, ruleset: ruleset
    expect(enabled_unit.internal_description).to eq("American army - Rifles")
  end

  it "sets defaults on initialize" do
    enabled_unit = create :enabled_unit
    expect(enabled_unit.callin_modifier).to eq 1
    expect(enabled_unit.upgrade_slots).to eq 0
    expect(enabled_unit.unitwide_upgrade_slots).to eq 0
  end
end


