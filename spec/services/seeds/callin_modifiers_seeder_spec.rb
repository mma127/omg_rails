require 'rails_helper'

RSpec.describe Seeds::CallinModifiersSeeder do
  let(:ruleset) { create :ruleset }

  let(:test_csv) { CSV.open("spec/support/seeds/callin_modifiers.csv", headers: true) }
  let(:factions_csv) { CSV.open("spec/support/seeds/factions.csv", headers: true) }
  let(:doctrines_csv) { CSV.open("spec/support/seeds/doctrines.csv", headers: true) }
  let(:units_csv) { CSV.open("spec/support/seeds/units.csv", headers: true) }
  let(:transport_allowed_units_csv) { CSV.open("spec/support/seeds/transport_allowed_units.csv", headers: true) }
  let(:unit_vet_csv) { CSV.open("spec/support/seeds/unit_vet.csv", headers: true) }
  let(:unlocks_csv) { CSV.open("spec/support/seeds/doctrineabilities.csv", headers: true) }

  before do
    allow(described_class).to receive(:callin_modifiers_csv).and_return test_csv
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
  end

  describe "#create_for_ruleset" do
    subject { described_class.create_for_ruleset(ruleset) }

    context "when there are no callin modifiers" do
      it "creates the expected callin modifiers" do
        expect { subject }.to change { CallinModifier.count }.by 5
      end

      it "creates the expected enabled callin modifiers" do
        expect { subject }.to change { EnabledCallinModifier.count }.by 5
      end

      it "creates the expected CallinModifierRequiredUnits" do
        expect { subject }.to change { CallinModifierRequiredUnit.count }.by 15
      end

      it "creates the expected CallinModifierAllowedUnit" do
        expect { subject }.to change { CallinModifierAllowedUnit.count }.by 16
      end
    end
  end

end
