# == Schema Information
#
# Table name: upgrades
#
#  id                                                                                 :bigint           not null, primary key
#  additional_model_count(How many model entities this upgrade adds to the base unit) :integer
#  const_name(Upgrade const name used by the battlefile)                              :string
#  description(Upgrade description)                                                   :string
#  disabled(override that disables the upgrade from being purchased or used)          :boolean          default(FALSE), not null
#  display_name(Display upgrade name)                                                 :string           not null
#  model_count(How many model entities this unit replacement consists of)             :integer
#  name(Unique upgrade name)                                                          :string           not null
#  type(Type of Upgrade)                                                              :string           not null
#  created_at                                                                         :datetime         not null
#  updated_at                                                                         :datetime         not null
#
# Indexes
#
#  index_upgrades_on_name  (name) UNIQUE
#
require "rails_helper"

RSpec.describe Upgrade, type: :model do
  let!(:upgrade) { create :upgrade }

  describe 'associations' do
    it { should have_many(:available_upgrades) }
  end

  describe "scopes" do
    describe "active" do
      subject { Upgrade.active }

      it { should include upgrade }

      context "when upgrade is disabled" do
        let(:upgrade) { create :upgrade, disabled: true }

        it { should_not include upgrade }
      end
    end
  end
end
