# == Schema Information
#
# Table name: upgrades
#
#  id                                                                                 :bigint           not null, primary key
#  additional_model_count(How many model entities this upgrade adds to the base unit) :integer
#  const_name(Upgrade const name used by the battlefile)                              :string
#  description(Upgrade description)                                                   :string
#  display_name(Display upgrade name)                                                 :string           not null
#  model_count(How many model entities this unit replacement consists of)             :integer
#  name(Unique upgrade name)                                                          :string           not null
#  type(Type of Upgrade)                                                              :string           not null
#  unitwide_upgrade_slots(Upgrade slot cost for unit wide upgrades)                   :integer
#  upgrade_slots(Upgrade slot cost for per model upgrades)                            :integer
#  created_at                                                                         :datetime         not null
#  updated_at                                                                         :datetime         not null
#
require "rails_helper"

RSpec.describe Upgrades::Passive, type: :model do
  let!(:passive) { create :passive }

  describe 'associations' do

  end

  describe 'validations' do
    it { should_not validate_presence_of(:model_count) }
  end
end
