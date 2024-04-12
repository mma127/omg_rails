require 'rails_helper'

RSpec.describe Seeds::DoctrinesSeeder do
  let(:factions_csv) { CSV.open("spec/support/seeds/factions.csv", headers: true) }
  let(:test_csv) { CSV.open("spec/support/seeds/doctrines.csv", headers: true) }

  before do
    allow(Seeds::FactionsSeeder).to receive(:factions_csv).and_return factions_csv
    allow(described_class).to receive(:doctrines_csv).and_return test_csv

    Seeds::FactionsSeeder.update_or_create_all
  end

  describe "#update_or_create_all" do
    subject { described_class.update_or_create_all }

    context "when there are no existing doctrines" do
      it "creates all expected doctrines" do
        expect { subject }.to change { Doctrine.count }.by 12
      end

      it "creates all expected faction restrictions" do
        expect { subject }.to change { Restriction.count }.by 12
        expect(Doctrine.all.map(&:restriction).all? { |r| r.present? }).to be true
      end
    end

    context "when some doctrines exist" do
      let!(:airborne) { create :doctrine, name: "airborne", display_name: "adfasdf" }
      let!(:infantry) { create :doctrine, name: "infantry", display_name: "incorrect" }

      before do
        create :restriction, :with_doctrine, doctrine: airborne
      end

      it "creates only the missing doctrines" do
        expect { subject }.to change { Doctrine.count }.by 10
      end

      it "updates the existing doctrines" do
        subject
        expect(airborne.reload.display_name).to eq "Airborne"
        expect(infantry.reload.display_name).to eq "Infantry"
      end

      it "creates the missing restrictions" do
        expect { subject }.to change { Restriction.count }.by 11
        expect(Doctrine.all.map(&:restriction).all? { |r| r.present? }).to be true
      end
    end
  end
end
