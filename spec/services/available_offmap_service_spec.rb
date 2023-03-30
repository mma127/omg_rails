require "rails_helper"

RSpec.describe AvailableOffmapService do
  let!(:player) { create :player }
  let!(:ruleset) { create :ruleset }
  let(:faction) { create :faction }
  let(:faction2) { create :faction }
  let(:doctrine) { create :doctrine, faction: faction }
  let!(:company) { create :company, faction: faction, doctrine: doctrine, ruleset: ruleset }
  let!(:restriction_faction) { create :restriction, faction: faction, doctrine: nil, unlock: nil, description: "for faction #{faction.id}" }
  let!(:restriction_faction2) { create :restriction, faction: faction2, doctrine: nil, unlock: nil, description: "for faction #{faction2.id}" }
  let!(:restriction_doctrine) { create :restriction, faction: nil, doctrine: doctrine, unlock: nil, name: "doctrine level", description: "for doctrine #{doctrine.id}" }
  let(:offmap1) { create :offmap }
  let(:offmap2) { create :offmap }
  let(:offmap3) { create :offmap }
  let!(:restriction_offmap1) { create :restriction_offmap, ruleset: ruleset, restriction: restriction_faction, offmap: offmap1, mun: 100, max: 1 }
  let!(:restriction_offmap2) { create :restriction_offmap, ruleset: ruleset, restriction: restriction_faction2, offmap: offmap2, mun: 120, max: 2 }
  let!(:restriction_offmap3) { create :restriction_offmap, ruleset: ruleset, restriction: restriction_doctrine, offmap: offmap3, mun: 150, max: 4 }

  subject(:instance) { described_class.new(company) }

  context "#build_new_company_available_offmaps" do
    subject { instance.build_new_company_available_offmaps }

    it "creates the correct number of AvailableOffmaps" do
      subject

      available_offmaps = company.reload.available_offmaps
      expect(available_offmaps.size).to eq 2
      expect(available_offmaps.pluck(:offmap_id)).to match_array [offmap1.id, offmap3.id]
    end

    it "creates the AvailableOffmap for offmap1" do
      subject
      ao = BaseAvailableOffmap.find_by(company: company, offmap: offmap1)
      expect(ao.mun).to eq 100
      expect(ao.max).to eq 1
      expect(ao.available).to eq 1
    end

    it "creates the AvailableOffmap for offmap3" do
      subject
      ao = BaseAvailableOffmap.find_by(company: company, offmap: offmap3)
      expect(ao.mun).to eq 150
      expect(ao.max).to eq 4
      expect(ao.available).to eq 4
    end

    context "when the company has existing AvailableOffmaps" do
      before do
        create :available_offmap, company: company, offmap: offmap1
      end

      it "raises an error" do
        expect { subject }.to raise_error "Company #{company.id} has existing AvailableOffmaps"
      end
    end
  end

  context "#create_enabled_available_offmaps" do
    context "when the company is valid" do
      before do
        offmap_hash = { offmap1.id => restriction_offmap1, offmap2.id => restriction_offmap2 }
        instance.create_enabled_available_offmaps(offmap_hash.values)
      end

      it "creates AvailableOffmaps from the given restriction offmaps" do
        available_offmaps = BaseAvailableOffmap.where(company: company)
        expect(available_offmaps.size).to eq 2
        expect(available_offmaps.pluck(:offmap_id)).to match_array [offmap1.id, offmap2.id]
      end

      it "creates an AvailableOffmap for offmap1 with the correct attributes" do
        ao = BaseAvailableOffmap.find_by(company: company, offmap: offmap1)
        expect(ao.mun).to eq 100
        expect(ao.max).to eq 1
        expect(ao.available).to eq 1
      end

      it "creates an AvailableOffmap for offmap2 with the correct attributes" do
        ao = BaseAvailableOffmap.find_by(company: company, offmap: offmap2)
        expect(ao.mun).to eq 120
        expect(ao.max).to eq 2
        expect(ao.available).to eq 2
      end
    end

    context "when the company has existing AvailableOffmaps" do
      before do
        create :available_offmap, company: company, offmap: offmap1
      end
      it "doesn't raise an error, because it doesn't matter to this method" do
        expect { instance.create_enabled_available_offmaps([]) }.not_to raise_error
      end
    end
  end
end
