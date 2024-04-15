# == Schema Information
#
# Table name: resource_bonuses
#
#  id                        :bigint           not null, primary key
#  fuel(Fuel change)         :integer          default(0), not null
#  man(Man change)           :integer          default(0), not null
#  mun(Mun change)           :integer          default(0), not null
#  name(Resource bonus name) :string           not null
#  resource(Resource type)   :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  ruleset_id                :bigint           not null
#
# Indexes
#
#  index_resource_bonuses_on_resource_and_ruleset_id  (resource,ruleset_id) UNIQUE
#  index_resource_bonuses_on_ruleset_id               (ruleset_id)
#
# Foreign Keys
#
#  fk_rails_...  (ruleset_id => rulesets.id)
#
require "rails_helper"

RSpec.describe ResourceBonus, type: :model do
  let(:resource_bonus) { create :resource_bonus }

  describe 'associations' do
    it { should belong_to(:ruleset) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:resource) }
    it { should validate_presence_of(:man) }
    it { should validate_presence_of(:mun) }
    it { should validate_presence_of(:fuel) }
    it { should validate_numericality_of(:man) }
    it { should validate_numericality_of(:mun) }
    it { should validate_numericality_of(:fuel) }
  end
end
