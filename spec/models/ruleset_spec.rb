# == Schema Information
#
# Table name: rulesets
#
#  id                                      :bigint           not null, primary key
#  description(Description)                :string
#  name(Ruleset name)                      :string           not null
#  starting_fuel(Company starting fuel)    :integer          not null
#  starting_man(Company starting manpower) :integer          not null
#  starting_mun(Company starting muntions) :integer          not null
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#
require "rails_helper"

RSpec.describe Ruleset, type: :model do
  let!(:ruleset) { create :ruleset}

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:starting_man) }
    it { should validate_presence_of(:starting_mun) }
    it { should validate_presence_of(:starting_fuel) }
    it { should validate_numericality_of(:starting_man) }
    it { should validate_numericality_of(:starting_mun) }
    it { should validate_numericality_of(:starting_fuel) }
  end
end


