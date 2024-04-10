require 'rails_helper'

RSpec.describe Seeds::FactionsService do
  describe "#update_or_create_all" do
    subject { described_class.update_or_create_all }

    context "when there are no existing factions" do
      it "creates all expected factions" do
        expect { subject }.to change { Faction.count }.by 4
        expect(Faction.pluck(:name)).to match_array %w[americans british wehrmacht panzer_elite]
      end

      it "creates all expected faction restrictions" do
        expect { subject }.to change { Restriction.count }.by 4
        expect(Faction.all.map(&:restriction).all? { |r| r.present? }).to be true
      end
    end

    context "when some factions exist" do
      let!(:americans) { create :faction, name: "americans", display_name: "adfasdf" }
      let!(:british) { create :faction, name: "british", display_name: "incorrect" }

      before do
        create :restriction, faction: americans
      end

      it "creates only the missing factions" do
        expect { subject }.to change { Faction.count }.by 2
        expect(Faction.pluck(:name)).to match_array %w[americans british wehrmacht panzer_elite]
      end

      it "updates the existing factions" do
        subject
        expect(americans.reload.display_name).to eq "Americans"
        expect(british.reload.display_name).to eq "British"
      end

      it "creates the missing restrictions" do
        expect { subject }.to change { Restriction.count }.by 3
        expect(Faction.all.map(&:restriction).all? { |r| r.present? }).to be true
      end
    end
  end
end
