require 'rails_helper'

RSpec.describe Seeds::ResourceBonusesSeeder do
  let(:ruleset) { create :ruleset }

  describe "#create_for_ruleset" do
    subject { described_class.create_for_ruleset(ruleset) }

    it "creates new resource bonuses for the ruleset" do
      expect { subject }.to change { ResourceBonus.count }.by 3
    end

    it "creates the expected resource bonuses" do
      subject

      expect(ResourceBonus.all.pluck(:resource)).to match_array ResourceBonus.resources.keys
    end
  end
end
