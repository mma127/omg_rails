require 'rails_helper'

RSpec.describe Seeds::RulesetSeeder do
  let(:name) { "new war" }
  let(:ruleset_type) { Ruleset.ruleset_types[:war] }
  let(:test_csv) { CSV.open("spec/support/seeds/rulesets.csv", headers: true) }

  before do
    allow(described_class).to receive(:ruleset_csv).and_return test_csv
  end

  describe "#create_new_ruleset" do
    subject { described_class.create_new_ruleset(ruleset_type, name) }

    context "when there are no pre-existing rulesets" do
      it "creates a new ruleset" do
        expect(Ruleset.count).to eq 0
        expect { subject }.to change { Ruleset.count }.by 1
      end

      it "creates an active ruleset with the given name" do
        new_ruleset = subject
        expect(new_ruleset.is_active).to be true
        expect(new_ruleset.ruleset_type).to eq ruleset_type
        expect(new_ruleset.name).to eq name
      end
    end

    context "when there are pre-existing rulesets" do
      let!(:existing_ruleset) { create :ruleset }

      before do
        create :ruleset, is_active: false
        create :ruleset, is_active: false
      end

      it "creates a new ruleset" do
        expect(Ruleset.count).to eq 3
        expect { subject }.to change { Ruleset.count }.by 1
      end

      it "creates an active ruleset with the given name" do
        new_ruleset = subject
        expect(new_ruleset.is_active).to be true
        expect(new_ruleset.ruleset_type).to eq ruleset_type
        expect(new_ruleset.name).to eq name
      end

      it "marks the formerly active ruleset as not active" do
        subject
        expect(existing_ruleset.reload.is_active).to be false
      end
    end

    context "when the requested ruleset is not in the csv" do
      let(:ruleset_type) { "Invalid type" }

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "No row found matching ruleset type Invalid type in seed file [lib/assets/rulesets.csv]")
      end
    end
  end
end
