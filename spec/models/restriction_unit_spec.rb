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

RSpec.describe RestrictionUnit, type: :model do
  let!(:restriction_unit) { create :restriction_unit}

  describe 'associations' do
    it { should belong_to(:restriction) }
    it { should belong_to(:unit) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:man) }
    it { should validate_numericality_of(:mun) }
    it { should validate_numericality_of(:fuel) }
    it { should validate_numericality_of(:pop) }
    it { should validate_numericality_of(:callin_modifier) }
    it { should validate_numericality_of(:resupply) }
    it { should validate_numericality_of(:resupply_max) }
    it { should validate_numericality_of(:company_max) }
    it { should validate_uniqueness_of(:unit_id).scoped_to(:restriction_id) }
  end
end

