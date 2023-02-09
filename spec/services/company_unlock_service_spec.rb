require "rails_helper"

RSpec.describe CompanyUnlockService do
  let!(:ruleset) { create :ruleset }
  let!(:doctrine) { create :doctrine }
  let(:vps_current) { 10 }
  let!(:company) { create :company, doctrine: doctrine, vps_current: vps_current }
  let!(:unlock1) { create :unlock }
  let(:vp_cost) { 3 }
  let!(:doctrine_unlock) { create :doctrine_unlock, doctrine: doctrine, unlock: unlock1, vp_cost: vp_cost }
  let!(:du_restriction) { create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock }
  let!(:unit1) { create :unit }
  let!(:unit2) { create :unit }
  let!(:unit3) { create :unit }
  let!(:default_available) { 10 }
  let!(:new_unit_available) { 4 }
  let(:man) { 250 }
  let(:resupply_max) { 10 }

  subject(:instance) { described_class.new(company) }

  describe "#purchase_doctrine_unlock" do
    subject { instance.purchase_doctrine_unlock(doctrine_unlock) }

    context "when units are enabled for the company only" do
      let!(:du_enabled_unit) { create :enabled_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                      man: man, resupply_max: resupply_max }

      it "creates an available_unit for the enabled unit" do
        expect { subject }.to change { AvailableUnit.count }.by 1
        new_au = AvailableUnit.last
        expect(new_au.unit_id).to eq unit1.id
        expect(new_au.man).to eq man
        expect(new_au.resupply_max).to eq resupply_max
      end

      it "doesn't recalculate resources" do
        company_service_double = double
        allow(CompanyService).to receive(:new).and_return company_service_double
        expect(company_service_double).not_to receive(:recalculate_resources)
        subject
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when units are disabled for the company only" do
      let!(:du_disabled_unit) { create :disabled_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                       man: man, resupply_max: resupply_max }
      let!(:au1) { create :base_available_unit, company: company, unit: unit1 }
      let!(:au2) { create :base_available_unit, company: company, unit: unit2 }
      let!(:squad1) { create :squad, company: company, available_unit: au1 }
      let!(:squad2) { create :squad, company: company, available_unit: au1 }
      let!(:squad3) { create :squad, company: company, available_unit: au2 }

      it "removes the available_unit for the disabled unit" do
        expect { subject }.to change { AvailableUnit.count }.by -1
        expect(AvailableUnit.exists?(au1.id)).to be false
        expect(au2.destroyed?).to be false
      end

      it "removes squads associated with the disabled unit" do
        expect { subject }.to change { Squad.count }.by -2
        expect(Squad.exists?(squad1.id)).to be false
        expect(Squad.exists?(squad2.id)).to be false
        expect(Squad.exists?(squad3.id)).to be true
      end

      it "recalculates resources" do
        company_service_double = double
        allow(CompanyService).to receive(:new).and_return company_service_double
        expect(company_service_double).to receive(:recalculate_resources)
        subject
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when units are enabled/disabled and swapped" do
      let!(:du_enabled_unit) { create :enabled_unit, restriction: du_restriction, unit: unit3, ruleset: ruleset,
                                      man: man, resupply_max: new_unit_available }
      let!(:du_disabled_unit) { create :disabled_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset }
      let!(:au1) { create :base_available_unit, company: company, unit: unit1, available: default_available }
      let!(:au2) { create :base_available_unit, company: company, unit: unit2, available: default_available }
      let!(:unit_swap) { create :unit_swap, unlock: unlock1, old_unit: unit1, new_unit: unit3 }
      let!(:squad1) { create :squad, company: company, available_unit: au1 }
      let!(:squad2) { create :squad, company: company, available_unit: au1 }
      let!(:squad3) { create :squad, company: company, available_unit: au2 }
      let!(:squad4) { create :squad, company: company, available_unit: au2 }

      it "creates an available_unit for the enabled unit" do
        subject
        new_au = AvailableUnit.last
        expect(new_au.unit_id).to eq unit3.id
        expect(new_au.man).to eq man
        expect(new_au.resupply_max).to eq new_unit_available
      end

      it "removes the available_unit for the disabled unit" do
        subject
        expect(AvailableUnit.exists?(au1.id)).to be false
        expect(au2.destroyed?).to be false
      end

      it "updates squads containing the old unit" do
        subject
        new_au = AvailableUnit.last
        expect(squad1.reload.available_unit).to eq new_au
        expect(squad2.reload.available_unit).to eq new_au
        expect(squad3.reload.available_unit).to eq au2
        expect(squad4.reload.available_unit).to eq au2
      end

      it "updates the new unit's available value" do
        subject
        new_au = AvailableUnit.last
        expect(au2.reload.available).to eq default_available
        expect(new_au.reload.available).to eq new_unit_available - 2
      end

      it "recalculates resources" do
        company_service_double = double
        allow(CompanyService).to receive(:new).and_return company_service_double
        expect(company_service_double).to receive(:recalculate_resources)
        subject
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    it "fails when the company does not have the matching doctrine for the given doctrine_unlock" do
      new_doctrine = create :doctrine
      company.update!(doctrine: new_doctrine)
      expect { instance.purchase_doctrine_unlock(doctrine_unlock) }.
        to raise_error "Company #{company.id} has doctrine #{new_doctrine.name} but doctrine unlock #{doctrine_unlock.id} belongs to doctrine #{doctrine.name}"
    end

    context "when vps_current is too low" do
      let(:vps_current) { 2 }

      it "fails when the company does not have sufficient vps_current to purchase the doctrine_unlock" do
        expect { instance.purchase_doctrine_unlock(doctrine_unlock) }.
          to raise_error "Company #{company.id} has insufficient VPs to purchase doctrine unlock #{doctrine_unlock.id}, have #{vps_current} need #{vp_cost}"
      end
    end

    it "fails when the company already has a company_unlock for the given doctrine_unlock" do
      create :company_unlock, company: company, doctrine_unlock: doctrine_unlock
      expect { instance.purchase_doctrine_unlock(doctrine_unlock) }.
        to raise_error "Company #{company.id} already owns doctrine unlock #{doctrine_unlock.id}"
    end
  end

  describe "#swap_squad_units" do
    let!(:au1) { create :base_available_unit, company: company, unit: unit1, available: default_available }
    let!(:au2) { create :base_available_unit, company: company, unit: unit2, available: default_available }
    let!(:au3) { create :base_available_unit, company: company, unit: unit3, available: new_unit_available }
    let!(:unit_swap) { create :unit_swap, unlock: unlock1, old_unit: unit1, new_unit: unit3 }

    context "when there are squads containing old units" do
      let!(:squad1) { create :squad, company: company, available_unit: au1 }
      let!(:squad2) { create :squad, company: company, available_unit: au1 }
      let!(:squad3) { create :squad, company: company, available_unit: au2 }
      let!(:squad4) { create :squad, company: company, available_unit: au2 }

      it "updates squads containing the old unit" do
        instance.send(:swap_squad_units, [squad1, squad2, squad3, squad4], [unit_swap])
        expect(squad1.reload.available_unit).to eq au3
        expect(squad2.reload.available_unit).to eq au3
        expect(squad3.reload.available_unit).to eq au2
        expect(squad4.reload.available_unit).to eq au2
      end

      it "updates the new unit's available value" do
        instance.send(:swap_squad_units, [squad1, squad2, squad3, squad4], [unit_swap])
        expect(au1.reload.available).to eq default_available
        expect(au2.reload.available).to eq default_available
        expect(au3.reload.available).to eq 2
      end
    end

    context "when there are no squads containing old units" do
      let!(:squad3) { create :squad, company: company, available_unit: au2 }
      let!(:squad4) { create :squad, company: company, available_unit: au2 }

      it "does not change the existing squads" do
        instance.send(:swap_squad_units, [squad3, squad4], [unit_swap])
        expect(squad3.reload.available_unit).to eq au2
        expect(squad4.reload.available_unit).to eq au2
      end

      it "does not change the new unit's available value" do
        instance.send(:swap_squad_units, [squad3, squad4], [unit_swap])
        expect(au1.reload.available).to eq default_available
        expect(au2.reload.available).to eq default_available
        expect(au3.reload.available).to eq new_unit_available
      end
    end

    context "when the new unit to swap to is not available for the company" do
      let!(:au3) { nil }
      let!(:squad1) { create :squad, company: company, available_unit: au1 }
      let!(:squad2) { create :squad, company: company, available_unit: au1 }
      let!(:squad3) { create :squad, company: company, available_unit: au2 }
      let!(:squad4) { create :squad, company: company, available_unit: au2 }

      it "does not update squads containing the old unit" do
        instance.send(:swap_squad_units, [squad1, squad2, squad3, squad4], [unit_swap])
        expect(squad1.reload.available_unit).to eq au1
        expect(squad2.reload.available_unit).to eq au1
        expect(squad3.reload.available_unit).to eq au2
        expect(squad4.reload.available_unit).to eq au2
      end
    end
  end

  describe "#pay_for_company_unlock" do
    it "creates a CompanyUnlock for the Company and DoctrineUnlock" do
      expect { instance.send(:pay_for_company_unlock, doctrine_unlock) }.to change { CompanyUnlock.count }.by 1
      expect(company.company_unlocks.size).to eq 1
      expect(company.company_unlocks.first.doctrine_unlock).to eq doctrine_unlock
    end

    it "updates the Company's vps_current to pay for the DoctrineUnlock" do
      instance.send(:pay_for_company_unlock, doctrine_unlock)
      expect(company.reload.vps_current).to eq vps_current - vp_cost
    end
  end

  describe "#validate_correct_doctrine" do
    it "passes when the company has the matching doctrine for the given doctrine_unlock" do
      expect { instance.send(:validate_correct_doctrine, doctrine_unlock) }.not_to raise_error
    end

    it "fails when the company does not have the matching doctrine for the given doctrine_unlock" do
      new_doctrine = create :doctrine
      company.update!(doctrine: new_doctrine)
      expect { instance.send(:validate_correct_doctrine, doctrine_unlock) }.
        to raise_error "Company #{company.id} has doctrine #{new_doctrine.name} but doctrine unlock #{doctrine_unlock.id} belongs to doctrine #{doctrine.name}"
    end
  end

  describe "#validate_sufficient_vps" do
    it "passes when the company has sufficient vps_current to purchase the doctrine_unlock" do
      expect { instance.send(:validate_sufficient_vps, doctrine_unlock) }.not_to raise_error
    end

    context "when vps_current is too low" do
      let(:vps_current) { 2 }

      it "fails when the company does not have sufficient vps_current to purchase the doctrine_unlock" do
        expect { instance.send(:validate_sufficient_vps, doctrine_unlock) }.
          to raise_error "Company #{company.id} has insufficient VPs to purchase doctrine unlock #{doctrine_unlock.id}, have #{vps_current} need #{vp_cost}"
      end
    end
  end

  describe "#validate_unpurchased" do
    it "passes when the company does not have a company_unlock for the given doctrine_unlock" do
      expect { instance.send(:validate_unpurchased, doctrine_unlock) }.not_to raise_error
    end

    it "fails when the company already has a company_unlock for the given doctrine_unlock" do
      create :company_unlock, company: company, doctrine_unlock: doctrine_unlock
      expect { instance.send(:validate_unpurchased, doctrine_unlock) }.
        to raise_error "Company #{company.id} already owns doctrine unlock #{doctrine_unlock.id}"
    end
  end
end
