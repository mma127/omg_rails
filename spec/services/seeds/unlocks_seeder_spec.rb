require 'rails_helper'

RSpec.describe Seeds::UnlocksSeeder do
  let(:ruleset) { create :ruleset }
  let(:unlocks_csv) { CSV.open("spec/support/seeds/doctrineabilities.csv", headers: true) }
  let(:factions_csv) { CSV.open("spec/support/seeds/factions.csv", headers: true) }
  let(:doctrines_csv) { CSV.open("spec/support/seeds/doctrines.csv", headers: true) }

  before do
    allow(described_class).to receive(:unlocks_csv).and_return unlocks_csv
    allow(Seeds::FactionsSeeder).to receive(:factions_csv).and_return factions_csv
    allow(Seeds::DoctrinesSeeder).to receive(:doctrines_csv).and_return doctrines_csv

    Seeds::FactionsSeeder.update_or_create_all
    Seeds::DoctrinesSeeder.update_or_create_all
  end

  describe "#create_for_ruleset" do
    subject { described_class.create_for_ruleset(ruleset) }

    it "creates the expected unlocks" do
      expect { subject }.to change { Unlock.count }.by 216
    end

    it "creates the expected doctrine unlocks" do
      expect { subject }.to change { DoctrineUnlock.count }.by 216
    end

    it "creates the expected unlock restrictions" do
      expect { subject }.to change { Restriction.where.not(unlock_id: nil).count }.by 216
    end

    it "creates the expected doctrine unlock restrictions" do
      expect { subject }.to change { Restriction.where.not(doctrine_unlock_id: nil).count }.by 216
    end
  end
end
