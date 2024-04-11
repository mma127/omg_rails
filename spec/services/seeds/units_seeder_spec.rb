require 'rails_helper'

RSpec.describe Seeds::UnitsSeeder do

  describe "#create_or_update_all" do
    subject { described_class.create_or_update_all }

    context "when there are no existing units" do
      it "creates all units" do
        expect { subject }.to change { Unit.count }.by 157
      end

      it "creates all transport allowed units" do
        expect { subject }.to change { TransportAllowedUnit.count }.by 105
      end
    end

    context "when there are some units" do
      let!(:riflemen) { create :unit, name: "riflemen", const_name: "Garbage" }
      let!(:m10) { create :unit, name: "m10", const_name: "asdfasdf" }
      let!(:halftrack_allied) { create :unit, name: "halftrack_allied", const_name: "asdfasdf" }

      before do
        create :transport_allowed_unit, transport: halftrack_allied, allowed_unit: riflemen
      end

      it "creates the missing units" do
        expect { subject }.to change { Unit.count }.by 154
      end

      it "creates the missing transport allowed units" do
        expect { subject }.to change { TransportAllowedUnit.count }.by 104
      end

      it "updates the existing units" do
        subject

        expect(riflemen.reload.const_name).to eq "ALLY.RIFLEMEN"
        expect(m10.reload.const_name).to eq "ALLY.TANK_DESTROYER"
        expect(halftrack_allied.reload.const_name).to eq "ALLY.HALFTRACK"
      end
    end

    context "when there are all units already existing" do
      before do
        subject
      end

      it "does not add any new units" do
        expect { subject }.not_to change { Unit.count }
      end

      it "does not add any new transport allowed units" do
        expect { subject }.not_to change { TransportAllowedUnit.count }
      end
    end
  end
end
