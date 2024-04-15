require 'rails_helper'

RSpec.describe Seeds::RestrictionUnitsSeeder do
  let(:ruleset) { create :ruleset }

  let(:test_csv) { CSV.open("spec/support/seeds/unit_restrictions.csv", headers: true) }
  let(:unit_swaps_csv) { CSV.open("spec/support/seeds/unit_swaps.csv", headers: true) }
  let(:factions_csv) { CSV.open("spec/support/seeds/factions.csv", headers: true) }
  let(:doctrines_csv) { CSV.open("spec/support/seeds/doctrines.csv", headers: true) }
  let(:units_csv) { CSV.open("spec/support/seeds/units.csv", headers: true) }
  let(:transport_allowed_units_csv) { CSV.open("spec/support/seeds/transport_allowed_units.csv", headers: true) }
  let(:unit_vet_csv) { CSV.open("spec/support/seeds/unit_vet.csv", headers: true) }
  let(:unlocks_csv) { CSV.open("spec/support/seeds/doctrineabilities.csv", headers: true) }

  let(:instance) { described_class.new(ruleset) }
  before do
    allow(Seeds::FactionsSeeder).to receive(:factions_csv).and_return factions_csv
    allow(Seeds::DoctrinesSeeder).to receive(:doctrines_csv).and_return doctrines_csv
    allow(Seeds::UnitsSeeder).to receive(:units_csv).and_return units_csv
    allow(Seeds::UnitsSeeder).to receive(:transport_allowed_csv).and_return transport_allowed_units_csv
    allow(Seeds::UnitsSeeder).to receive(:unit_vet_csv).and_return unit_vet_csv
    allow(Seeds::UnlocksSeeder).to receive(:unlocks_csv).and_return unlocks_csv

    Seeds::FactionsSeeder.update_or_create_all
    Seeds::DoctrinesSeeder.update_or_create_all
    Seeds::UnitsSeeder.create_or_update_all
    Seeds::UnlocksSeeder.create_for_ruleset(ruleset)

    allow(instance).to receive(:unit_restrictions_csv).and_return test_csv
    allow(instance).to receive(:unit_swaps_csv).and_return unit_swaps_csv
  end

  describe "#create_for_ruleset" do
    subject { instance.create_for_ruleset }

    context "when there are no restriction units" do
      it "creates the expected restriction units" do
        expect { subject }.to change { RestrictionUnit.count }.by 173
      end

      it "creates the expected unit swaps" do
        expect { subject }.to change { UnitSwap.count }.by 5
      end
    end
  end
end
