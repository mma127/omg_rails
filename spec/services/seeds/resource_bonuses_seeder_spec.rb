require 'rails_helper'

RSpec.describe Seeds::ResourceBonusesSeeder do
  let(:ruleset) { create :ruleset }

  let(:test_csv) { CSV.open("spec/support/seeds/resource_bonuses.csv", headers: true) }

  before do
    allow(described_class).to receive(:resource_bonuses_csv).and_return test_csv
  end

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
