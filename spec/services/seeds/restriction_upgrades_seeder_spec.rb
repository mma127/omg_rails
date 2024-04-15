require 'rails_helper'

RSpec.describe Seeds::RestrictionUpgradesSeeder do
  let(:ruleset) { create :ruleset }

  let(:csv_paths) { %w[spec/support/seeds/enabled_upgrades_ame.csv spec/support/seeds/enabled_upgrades_cmw.csv spec/support/seeds/enabled_upgrades_wehr.csv spec/support/seeds/enabled_upgrades_pe.csv] }
  let(:unit_restrictions_csv) { CSV.open("spec/support/seeds/unit_restrictions.csv", headers: true) }
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
    allow(Seeds::UpgradesSeeder).to receive(:csv_paths).and_return csv_paths

    Seeds::FactionsSeeder.update_or_create_all
    Seeds::DoctrinesSeeder.update_or_create_all
    Seeds::UnitsSeeder.create_or_update_all
    Seeds::UnlocksSeeder.create_for_ruleset(ruleset)
    Seeds::UpgradesSeeder.create_or_update_all

    restriction_units_seeder = Seeds::RestrictionUnitsSeeder.new(ruleset)
    allow(restriction_units_seeder).to receive(:unit_restrictions_csv).and_return unit_restrictions_csv
    allow(restriction_units_seeder).to receive(:unit_swaps_csv).and_return unit_swaps_csv
    restriction_units_seeder.create_for_ruleset

    allow(instance).to receive(:csv_paths).and_return csv_paths
  end

  describe "#create_for_ruleset" do
    subject { instance.create_for_ruleset }

    it "creates the expected restriction upgrades and restriction upgrade units" do
      expect { subject }.to change { RestrictionUpgrade.count }.by(260)
                                                               .and change { RestrictionUpgradeUnit.count }.by 386
    end

    it "creates the expected upgrade swaps and upgrade swap units" do
      expect { subject }.to change { UpgradeSwap.count }.by(2)
                                                        .and change { UpgradeSwapUnit.count }.by 2
    end
  end
end
