# == Schema Information
#
# Table name: available_units
#
#  id                                                                                    :bigint           not null, primary key
#  available(Number of this unit available to purchase for the company)                  :integer          default(0), not null
#  callin_modifier(Calculated base callin modifier of this unit for the company)         :decimal(, )      not null
#  company_max(Maximum number of the unit a company can hold)                            :integer          default(0), not null
#  fuel(Calculated fuel cost of this unit for the company)                               :integer          not null
#  man(Calculated man cost of this unit for the company)                                 :integer          not null
#  mun(Calculated mun cost of this unit for the company)                                 :integer          not null
#  pop(Calculated pop cost of this unit for the company)                                 :decimal(, )      not null
#  resupply(Per game resupply)                                                           :integer          default(0), not null
#  resupply_max(How much resupply is available from saved up resupplies, <= company max) :integer          default(0), not null
#  type(Type of available unit)                                                          :string           not null
#  created_at                                                                            :datetime         not null
#  updated_at                                                                            :datetime         not null
#  company_id                                                                            :bigint
#  unit_id                                                                               :bigint
#
# Indexes
#
#  index_available_units_on_company_id                       (company_id)
#  index_available_units_on_company_id_and_unit_id_and_type  (company_id,unit_id,type) UNIQUE
#  index_available_units_on_unit_id                          (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (unit_id => units.id)
#
require "rails_helper"

RSpec.describe AvailableUnit, type: :model do
  let!(:available_unit) { create :available_unit }

  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:unit) }
    it { should have_many(:squads) }
  end

  describe 'validations' do
    it { should validate_presence_of(:company) }
    it { should validate_presence_of(:unit) }
    it { should validate_presence_of(:available) }
    it { should validate_presence_of(:resupply) }
    it { should validate_presence_of(:resupply_max) }
    it { should validate_presence_of(:company_max) }
    it { should validate_presence_of(:pop) }
    it { should validate_presence_of(:man) }
    it { should validate_presence_of(:mun) }
    it { should validate_presence_of(:fuel) }
    it { should validate_presence_of(:callin_modifier) }
    it { should validate_numericality_of(:available).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:resupply).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:resupply_max).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:company_max).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:pop).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:man).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:mun).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:fuel).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:callin_modifier).is_greater_than_or_equal_to(0) }
  end

  it "gets the correct unit name" do
    unit = create :unit, name: "riflemen"
    au = create :available_unit, unit: unit, ruleset: available_unit.company.ruleset
    expect(au.unit_name).to eq("riflemen")
  end
  it "gets the correct unit display name" do
    unit = create :unit, display_name: "Riflemen"
    au = create :available_unit, unit: unit, ruleset: available_unit.company.ruleset
    expect(au.unit_display_name).to eq("Riflemen")
  end
  it "gets the correct unit type" do
    unit = create :infantry
    au = create :available_unit, unit: unit, ruleset: available_unit.company.ruleset
    expect(au.unit_type).to eq("Infantry")
  end
end
