require "rails_helper"

RSpec.describe CompanyBonusesService do
  let!(:player) { create :player }
  let(:max_resource_bonuses) { 5 }
  let!(:ruleset) { create :ruleset, max_resource_bonuses: max_resource_bonuses }
  let!(:man_rb) { create :resource_bonus, resource: "man", man: 100, mun: -10, fuel: -15 }
  let!(:mun_rb) { create :resource_bonus, resource: "mun", man: -50, mun: 40, fuel: -10 }
  let!(:fuel_rb) { create :resource_bonus, resource: "fuel", man: -60, mun: -20, fuel: 50 }
  let!(:company) { create :company, player: player }
  let(:company_id) { company.id }

  subject(:instance) { described_class.new(company_id, player) }

  describe "#get_company_resource_bonuses" do
    before do
      create :company_resource_bonus, company: company, resource_bonus: man_rb
      create :company_resource_bonus, company: company, resource_bonus: mun_rb
      create :company_resource_bonus, company: company, resource_bonus: mun_rb
      create :company_resource_bonus, company: company, resource_bonus: fuel_rb
      create :company_resource_bonus, company: company, resource_bonus: fuel_rb
    end

    it "returns the correct response" do
      result = instance.get_company_resource_bonuses
      expect(result[:resource_bonuses]).to match_array([man_rb, mun_rb, fuel_rb])
      expect(result[:man_bonus_count]).to eq 1
      expect(result[:mun_bonus_count]).to eq 2
      expect(result[:fuel_bonus_count]).to eq 2
      # expect(result[:current_man]).to eq ruleset.starting_man + man_rb.man + (mun_rb.man * 2) + (fuel_rb.man * 2)
      expect(result[:max_resource_bonuses]).to eq ruleset.max_resource_bonuses
    end
  end

  describe "#purchase_resource_bonus" do
    before do
      create :company_resource_bonus, company: company, resource_bonus: man_rb
      create :company_resource_bonus, company: company, resource_bonus: mun_rb
      create :company_resource_bonus, company: company, resource_bonus: mun_rb
      create :company_resource_bonus, company: company, resource_bonus: fuel_rb
    end

    it "adds a resource bonus to the company" do
      result = instance.purchase_resource_bonus(ResourceBonus.resources[:man])
      expect(result[:resource_bonuses]).to match_array([man_rb, mun_rb, fuel_rb])
      expect(result[:man_bonus_count]).to eq 2
      expect(result[:mun_bonus_count]).to eq 2
      expect(result[:fuel_bonus_count]).to eq 1
      expect(result[:current_man]).to eq ruleset.starting_man + (man_rb.man * 2) + (mun_rb.man * 2) + fuel_rb.man
      expect(result[:current_mun]).to eq ruleset.starting_mun + (man_rb.mun * 2) + (mun_rb.mun * 2) + fuel_rb.mun
      expect(result[:current_fuel]).to eq ruleset.starting_fuel + (man_rb.fuel * 2) + (mun_rb.fuel * 2) + fuel_rb.fuel
      expect(result[:max_resource_bonuses]).to eq ruleset.max_resource_bonuses
    end

    context "when a resource bonus cannot be added" do
      before do
        create :company_resource_bonus, company: company, resource_bonus: fuel_rb
      end

      it "raises an error" do
        expect { instance.purchase_resource_bonus(ResourceBonus.resources[:man]) }.
          to raise_error(CompanyBonusesService::CompanyBonusesError,
                         "Company #{company.id} cannot add more resource bonuses")
      end
    end
  end

  describe "#refund_resource_bonus" do
    context "when there are company resource bonuses of the requested type" do
      before do
        create :company_resource_bonus, company: company, resource_bonus: man_rb
        create :company_resource_bonus, company: company, resource_bonus: fuel_rb
      end

      it "removes the resource bonus from the company" do
        result = instance.refund_resource_bonus(ResourceBonus.resources[:man])
        expect(result[:resource_bonuses]).to match_array([man_rb, mun_rb, fuel_rb])
        expect(result[:man_bonus_count]).to eq 0
        expect(result[:mun_bonus_count]).to eq 0
        expect(result[:fuel_bonus_count]).to eq 1
        expect(result[:current_man]).to eq ruleset.starting_man + fuel_rb.man
        expect(result[:current_mun]).to eq ruleset.starting_mun + fuel_rb.mun
        expect(result[:current_fuel]).to eq ruleset.starting_fuel + fuel_rb.fuel
        expect(result[:max_resource_bonuses]).to eq ruleset.max_resource_bonuses
      end
    end

    context "when there are no company resource bonuses of the requested type" do
      let(:resource) { ResourceBonus.resources[:man] }
      it "raises an error" do
        expect { instance.refund_resource_bonus(resource) }.
          to raise_error(CompanyBonusesService::CompanyBonusesError,
                         "Company #{company.id} cannot refund resource bonus of type #{resource}, none exist.")
      end
    end
  end
end
