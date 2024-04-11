require 'rails_helper'

RSpec.describe Seeds::UnlocksSeeder do
  let(:ruleset) { create :ruleset }

  before do
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
