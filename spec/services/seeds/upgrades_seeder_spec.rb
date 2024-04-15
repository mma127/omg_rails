require 'rails_helper'

RSpec.describe Seeds::UpgradesSeeder do
  let(:csv_paths) { %w[spec/support/seeds/enabled_upgrades_ame.csv spec/support/seeds/enabled_upgrades_cmw.csv spec/support/seeds/enabled_upgrades_wehr.csv spec/support/seeds/enabled_upgrades_pe.csv] }
  before do
    allow(described_class).to receive(:csv_paths).and_return csv_paths
  end

  describe "#create_or_update_all" do
    subject { described_class.create_or_update_all }

    context "when there are no existing" do
      it "creates all upgrades" do
        expect { subject }.to change { Upgrade.count }.by 177
      end
    end

    context "when there are some existing upgrades" do
      before do
        create :consumable, name: "ally_grenade", const_name: "ALLY.GRENADE", display_name: "Grenades", description: "Line infantry grenades"
      end

      it "creates the missing upgrades" do
        expect { subject }.to change { Upgrade.count }.by 176
      end
    end
  end
end
