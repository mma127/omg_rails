# == Schema Information
#
# Table name: resource_bonuses
#
#  id                        :bigint           not null, primary key
#  fuel_lost(Fuel deducted)  :integer          default(0), not null
#  gained(Bonus amount)      :integer          default(0), not null
#  man_lost(Man deducted)    :integer          default(0), not null
#  mun_lost(Mun deducted)    :integer          default(0), not null
#  name(Resource bonus name) :string           not null
#  resource(Resource type)   :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require "rails_helper"

RSpec.describe ResourceBonus, type: :model do
  let(:resource_bonus) { create :resource_bonus }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:resource) }
    it { should validate_presence_of(:gained) }
    it { should validate_presence_of(:man_lost) }
    it { should validate_presence_of(:mun_lost) }
    it { should validate_presence_of(:fuel_lost) }
    it { should validate_numericality_of(:gained) }
    it { should validate_numericality_of(:man_lost) }
    it { should validate_numericality_of(:mun_lost) }
    it { should validate_numericality_of(:fuel_lost) }
  end
end
