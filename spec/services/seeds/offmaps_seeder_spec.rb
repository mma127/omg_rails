require 'rails_helper'

RSpec.describe Seeds::OffmapsSeeder do
  let(:ruleset) { create :ruleset }

  let(:test_csv) { CSV.open("spec/support/seeds/offmaps.csv", headers: true) }
  let(:factions_csv) { CSV.open("spec/support/seeds/factions.csv", headers: true) }
  let(:doctrines_csv) { CSV.open("spec/support/seeds/doctrines.csv", headers: true) }
  let(:unlocks_csv) { CSV.open("spec/support/seeds/doctrineabilities.csv", headers: true) }

  before do
    allow(described_class).to receive(:offmaps_csv).and_return test_csv
    allow(Seeds::FactionsSeeder).to receive(:factions_csv).and_return factions_csv
    allow(Seeds::DoctrinesSeeder).to receive(:doctrines_csv).and_return doctrines_csv
    allow(Seeds::UnlocksSeeder).to receive(:unlocks_csv).and_return unlocks_csv

    Seeds::FactionsSeeder.update_or_create_all
    Seeds::DoctrinesSeeder.update_or_create_all
    Seeds::UnlocksSeeder.create_for_ruleset(ruleset)
  end

  describe "#create_for_ruleset" do
    subject { described_class.create_for_ruleset(ruleset) }

    context "when there are no existing offmaps" do
      it "creates the expected offmaps" do
        expect { subject }.to change { Offmap.count }.by 33
      end

      it "creates the expected enabled offmaps" do
        expect { subject }.to change { RestrictionOffmap.count }.by 33
      end

      it "creates the enabled offmap for a doctrine unlock" do
        subject

        offmap = Offmap.find_by!(name: "bombing_run", ruleset_id: ruleset.id)
        enabled_offmap = EnabledOffmap.find_by(offmap_id: offmap.id, ruleset_id: ruleset.id)
        doctrine = Doctrine.find_by(name: "airborne")
        unlock = Unlock.find_by(name: "bombing_run")
        doctrine_unlock = DoctrineUnlock.find_by(doctrine_id: doctrine.id, unlock_id: unlock.id, ruleset_id: ruleset.id)
        du_restriction = Restriction.find_by!(doctrine_unlock_id: doctrine_unlock.id)
        expect(enabled_offmap.restriction).to eq du_restriction
      end

      it "creates the enabled offmap for a doctrine" do
        subject

        offmap = Offmap.find_by!(name: "105_barrage", ruleset_id: ruleset.id)
        enabled_offmap = EnabledOffmap.find_by(offmap_id: offmap.id, ruleset_id: ruleset.id)
        doctrine = Doctrine.find_by(name: "infantry")
        restriction = Restriction.find_by!(doctrine_id: doctrine.id)
        expect(enabled_offmap.restriction).to eq restriction
      end

      it "creates the enabled offmap for an unlock" do
        subject

        offmap = Offmap.find_by!(name: "glider_triage", ruleset_id: ruleset.id)
        enabled_offmap = EnabledOffmap.find_by(offmap_id: offmap.id, ruleset_id: ruleset.id)
        unlock = Unlock.find_by(name: "commando_hospitals")
        restriction = Restriction.find_by!(unlock_id: unlock.id)
        expect(enabled_offmap.restriction).to eq restriction
      end

      it "creates the enabled offmap for a faction" do
        subject

        offmap = Offmap.find_by!(name: "marksman", ruleset_id: ruleset.id)
        enabled_offmap = EnabledOffmap.find_by!(offmap_id: offmap.id, ruleset_id: ruleset.id)
        british_restriction = Restriction.find_by!(faction_id: Faction.find_by(name: "british").id)
        expect(enabled_offmap.restriction).to eq british_restriction
      end
    end
  end
end
