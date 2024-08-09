require "rails_helper"

RSpec.describe CompanyUnlockService do
  let!(:ruleset) { create :ruleset }
  let!(:faction) { create :faction }
  let!(:restriction_faction) { create :restriction, faction: faction }
  let!(:doctrine) { create :doctrine, faction: faction }
  let!(:restriction_doctrine) { create :restriction, :with_doctrine, doctrine: doctrine }
  let(:vps_current) { 10 }
  let(:starting_man) { ruleset.starting_man }
  let(:starting_mun) { ruleset.starting_mun }
  let(:starting_fuel) { ruleset.starting_fuel }
  let!(:company) { create :active_company, doctrine: doctrine, faction: faction, ruleset: ruleset, vps_current: vps_current, man: starting_man, mun: starting_mun, fuel: starting_fuel }
  let!(:unlock1) { create :unlock, ruleset: ruleset }
  let!(:unlock2) { create :unlock, ruleset: ruleset }
  let(:vp_cost) { 3 }
  let!(:doctrine_unlock) { create :doctrine_unlock, doctrine: doctrine, unlock: unlock1, vp_cost: vp_cost, ruleset: ruleset }
  let!(:du_restriction) { doctrine_unlock.restriction }
  let!(:doctrine_unlock2) { create :doctrine_unlock, doctrine: doctrine, unlock: unlock2, vp_cost: vp_cost, tree: 1, branch: 1, row: 2, ruleset: ruleset }
  let!(:du_restriction2) { doctrine_unlock2.restriction }
  let!(:unit1) { create :unit }
  let!(:unit2) { create :unit }
  let!(:unit3) { create :unit }
  let!(:offmap1) { create :offmap, ruleset: ruleset }
  let!(:callin_modifier) { create :callin_modifier }
  let!(:upgrade1) { create :upgrade }
  let!(:upgrade2) { create :upgrade }
  let!(:upgrade3) { create :upgrade }
  let!(:default_available) { 10 }
  let!(:new_unit_available) { 4 }
  let(:man1) { 250 }
  let(:mun1) { 120 }
  let(:fuel1) { 80 }
  let(:pop1) { 6 }
  let(:man2) { 600 }
  let(:mun2) { 40 }
  let(:fuel2) { 80 }
  let(:pop2) { 16 }
  let(:man3) { 100 }
  let(:mun3) { 70 }
  let(:fuel3) { 0 }
  let(:pop3) { 0 }
  let(:uses3) { 2 }
  let(:man4) { 500 }
  let(:mun4) { 90 }
  let(:fuel4) { 30 }
  let(:pop4) { 5 }
  let(:uses4) { 1 }
  let(:resupply_max) { 10 }

  subject(:instance) { described_class.new(company) }

  describe "#purchase_doctrine_unlock" do
    subject { instance.purchase_doctrine_unlock(doctrine_unlock) }

    context "when units are enabled for the company only" do
      let!(:du_enabled_unit) { create :enabled_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                      man: man1, resupply_max: resupply_max }

      it "creates an available_unit for the enabled unit" do
        expect { subject }.to change { AvailableUnit.count }.by 1
        new_au = AvailableUnit.last
        expect(new_au.unit_id).to eq unit1.id
        expect(new_au.man).to eq man1
        expect(new_au.resupply_max).to eq resupply_max
      end

      it "doesn't recalculate resources" do
        company_service_double = double
        allow(CompanyService).to receive(:new).and_return company_service_double
        expect(company_service_double).not_to receive(:recalculate_and_update_resources)
        subject
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when units are disabled for the company only" do
      let!(:du_disabled_unit) { create :disabled_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                       man: man1, mun: mun1, fuel: fuel1, pop: pop1, resupply_max: resupply_max }
      let!(:au1) { create :base_available_unit, company: company, unit: unit1 }
      let!(:au2) { create :base_available_unit, company: company, unit: unit2, man: man2, mun: mun2, fuel: fuel2, pop: pop2 }
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
        subject
        expect(company.reload.man).to eq ruleset.starting_man - man2
        expect(company.reload.mun).to eq ruleset.starting_mun - mun2
        expect(company.reload.fuel).to eq ruleset.starting_fuel - fuel2
        expect(company.reload.pop).to eq pop2
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when units are enabled/disabled and swapped" do
      let!(:du_enabled_unit) { create :enabled_unit, restriction: du_restriction, unit: unit3, ruleset: ruleset,
                                      man: man1, mun: mun1, fuel: fuel1, pop: pop1, resupply_max: new_unit_available }
      let!(:du_disabled_unit) { create :disabled_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset }
      let!(:au1) { create :base_available_unit, company: company, unit: unit1, available: default_available }
      let!(:au2) { create :base_available_unit, company: company, unit: unit2, man: man2, mun: mun2, fuel: fuel2, pop: pop2, available: default_available }
      let!(:unit_swap) { create :unit_swap, unlock: unlock1, old_unit: unit1, new_unit: unit3 }
      let!(:squad1) { create :squad, company: company, available_unit: au1 }
      let!(:squad2) { create :squad, company: company, available_unit: au1 }
      let!(:squad3) { create :squad, company: company, available_unit: au2 }
      let!(:squad4) { create :squad, company: company, available_unit: au2 }

      it "creates an available_unit for the enabled unit" do
        subject
        new_au = AvailableUnit.last
        expect(new_au.unit_id).to eq unit3.id
        expect(new_au.man).to eq man1
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
        subject
        expect(company.reload.man).to eq ruleset.starting_man - (man1 * 2) - (man2 * 2)
        expect(company.reload.mun).to eq ruleset.starting_mun - (mun1 * 2) - (mun2 * 2)
        expect(company.reload.fuel).to eq ruleset.starting_fuel - (fuel1 * 2) - (fuel2 * 2)
        expect(company.reload.pop).to eq pop1 * 2 + pop2 * 2
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when units are modified for the company only" do
      let(:add_man) { 100 }
      let(:add_fuel) { 25 }
      let(:add_pop) { -1 }
      let(:replace_fuel) { 0 }
      let(:replace_resupply) { 5 }
      let!(:doc_enabled_unit) { create :enabled_unit, restriction: restriction_doctrine, unit: unit1, ruleset: ruleset,
                                       man: man1, mun: mun1, fuel: fuel1, pop: pop1, resupply: resupply_max, resupply_max: resupply_max }
      let!(:au) { create :base_available_unit, company: company, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1,
                         resupply: resupply_max, resupply_max: resupply_max }

      let!(:du_modified_replace_unit) { create :modified_replace_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                               fuel: replace_fuel, resupply: replace_resupply, priority: 50 }
      let!(:du_modified_add_unit) { create :modified_add_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                           man: add_man, fuel: add_fuel, pop: add_pop, priority: 60 }

      it "applies modifications to the available unit, in order of priority" do
        subject
        expect(au.reload.man).to eq man1 + add_man
        expect(au.mun).to eq mun1
        expect(au.fuel).to eq replace_fuel + add_fuel
        expect(au.pop).to eq pop1 + add_pop
        expect(au.resupply).to eq replace_resupply
        expect(au.resupply_max).to eq resupply_max
      end

      it "recalculates resources" do
        company_service_double = double
        allow(CompanyService).to receive(:new).and_return company_service_double
        expect(company_service_double).to receive(:recalculate_and_update_resources)
        subject
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when offmaps are enabled for the company" do
      let!(:du_enabled_offmap) { create :enabled_offmap, restriction: du_restriction, offmap: offmap1, ruleset: ruleset, mun: 120, max: 2 }

      it "creates an AvailableOffmap for the enabled offmap" do
        expect { subject }.to change { AvailableOffmap.count }.by 1
        new_ao = AvailableOffmap.last
        expect(new_ao.offmap_id).to eq offmap1.id
        expect(new_ao.mun).to eq du_enabled_offmap.mun
        expect(new_ao.max).to eq du_enabled_offmap.max
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when callin modifier is enabled for the company" do
      let!(:du_enabled_callin_modifier) { create :enabled_callin_modifier, restriction: du_restriction, callin_modifier: callin_modifier, ruleset: ruleset }

      it "creates a CompanyCallinModifier for the enabled callin modifier" do
        expect { subject }.to change { CompanyCallinModifier.count }.by 1
        new_ccm = CompanyCallinModifier.last
        expect(new_ccm.callin_modifier).to eq callin_modifier
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when upgrades are enabled for the company only" do
      let!(:du_enabled_upgrade) { create :enabled_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset,
                                         man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:du_enabled_upgrade2) { create :enabled_upgrade, restriction: du_restriction2, upgrade: upgrade1, ruleset: ruleset }

      before do
        create :restriction_upgrade_unit, restriction_upgrade: du_enabled_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: du_enabled_upgrade, unit: unit2
        create :restriction_upgrade_unit, restriction_upgrade: du_enabled_upgrade2, unit: unit3
      end

      it "creates AvailableUpgrades for the enabled upgrade" do
        expect { subject }.to change { AvailableUpgrade.count }.by 2
        au1 = AvailableUpgrade.find_by(company: company, upgrade: upgrade1, unit: unit1)
        expect(au1.man).to eq man3
        expect(au1.mun).to eq mun3
        expect(au1.fuel).to eq fuel3
        expect(au1.pop).to eq pop3
        expect(au1.uses).to eq uses3
        au2 = AvailableUpgrade.find_by(company: company, upgrade: upgrade1, unit: unit2)
        expect(au2.man).to eq man3
        expect(au2.mun).to eq mun3
        expect(au2.fuel).to eq fuel3
        expect(au2.pop).to eq pop3
        expect(au2.uses).to eq uses3
      end

      it "does not create an AvailableUpgrade for enabled_upgrades not associated with the unlock" do
        subject
        expect(AvailableUpgrade.find_by(company: company, upgrade: upgrade1, unit: unit3)).to eq nil
      end

      it "doesn't recalculate resources" do
        company_service_double = double
        allow(CompanyService).to receive(:new).and_return company_service_double
        expect(company_service_double).not_to receive(:recalculate_and_update_resources)
        subject
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when upgrades are disabled for the company only" do
      let!(:au1) { create :base_available_unit, company: company, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1 }
      let!(:au2) { create :base_available_unit, company: company, unit: unit2, man: man2, mun: mun2, fuel: fuel2, pop: pop2 }
      let!(:squad1) { create :squad, company: company, available_unit: au1 }
      let!(:squad2) { create :squad, company: company, available_unit: au1 }
      let!(:squad3) { create :squad, company: company, available_unit: au2 }
      let!(:du_disabled_upgrade) { create :disabled_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset }
      let!(:available_upgrade1) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit1, man: man3, mun: mun3, fuel: fuel3 }
      let!(:available_upgrade2) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit2, man: man3, mun: mun3, fuel: fuel3 }
      let!(:squad_upgrade1) { create :squad_upgrade, squad: squad1, available_upgrade: available_upgrade1 }
      let!(:squad_upgrade2) { create :squad_upgrade, squad: squad3, available_upgrade: available_upgrade2 }

      before do
        create :restriction_upgrade_unit, restriction_upgrade: du_disabled_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: du_disabled_upgrade, unit: unit2
      end

      it "removes AvailableUpgrades associated" do
        expect { subject }.to change { AvailableUpgrade.count }.by(-2)
        expect(AvailableUpgrade.exists?(available_upgrade1.id)).to be false
        expect(AvailableUpgrade.exists?(available_upgrade2.id)).to be false
      end

      it "removes SquadUpgrades associated with the removed AvailableUpgrades" do
        expect { subject }.to change { SquadUpgrade.count }.by(-2)
        expect(SquadUpgrade.exists?(squad_upgrade1.id)).to be false
        expect(SquadUpgrade.exists?(squad_upgrade2.id)).to be false
      end

      it "recalculates resources" do
        subject
        expect(company.reload.man).to eq ruleset.starting_man - 2 * man1 - man2
        expect(company.reload.mun).to eq ruleset.starting_mun - 2 * mun1 - mun2
        expect(company.reload.fuel).to eq ruleset.starting_fuel - 2 * fuel1 - fuel2
        expect(company.reload.pop).to eq 2 * pop1 + pop2
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when upgrades are enabled/disabled and swapped" do
      let!(:du_enabled_upgrade) { create :enabled_upgrade, restriction: du_restriction, upgrade: upgrade2, ruleset: ruleset,
                                         man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:du_disabled_upgrade) { create :disabled_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset }
      let!(:upgrade_swap) { create :upgrade_swap, unlock: unlock1, old_upgrade: upgrade1, new_upgrade: upgrade2 }
      let!(:available_unit1) { create :base_available_unit, company: company, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1 }
      let!(:available_unit2) { create :base_available_unit, company: company, unit: unit2, man: man2, mun: mun2, fuel: fuel2, pop: pop2 }
      let!(:squad1) { create :squad, company: company, available_unit: available_unit1 }
      let!(:squad2) { create :squad, company: company, available_unit: available_unit2 }
      let!(:available_upgrade1) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit1 }
      let!(:available_upgrade2) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit2, man: man4, mun: mun4, fuel: fuel4, pop: pop4 }
      let!(:squad_upgrade1) { create :squad_upgrade, squad: squad1, available_upgrade: available_upgrade1 }
      let!(:squad_upgrade2) { create :squad_upgrade, squad: squad2, available_upgrade: available_upgrade2 }

      before do
        create :restriction_upgrade_unit, restriction_upgrade: du_enabled_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: du_disabled_upgrade, unit: unit1
        create :upgrade_swap_unit, upgrade_swap: upgrade_swap, unit: unit1
      end

      it "creates an AvailableUpgrade for the enabled upgrade" do
        expect { subject }.to change { AvailableUpgrade.count }.by 0 # -1 + 1
        expect(AvailableUpgrade.find_by(company: company, upgrade: upgrade2, unit: unit1)).to be_present
        expect(AvailableUpgrade.find_by(company: company, upgrade: upgrade2, unit: unit2)).not_to be_present # only upgrade for unit1 created
      end

      it "removes the AvailableUpgrade for the disabled upgrade" do
        subject
        expect(AvailableUpgrade.exists?(available_upgrade1.id)).to be false
        expect(AvailableUpgrade.exists?(available_upgrade2.id)).to be true # only upgrade for unit1 removed
      end

      it "swaps the AvailableUpgrade out in the relevant SquadUpgrades" do
        expect(squad_upgrade1.upgrade_id).to eq upgrade1.id
        expect(squad_upgrade2.upgrade_id).to eq upgrade1.id
        expect { subject }.to change { SquadUpgrade.count }.by 0 # Does not remove any
        au = AvailableUpgrade.find_by(company: company, upgrade: upgrade2, unit: unit1)
        expect(squad_upgrade1.reload.available_upgrade_id).to eq au.id
        expect(squad_upgrade2.reload.upgrade_id).to eq upgrade1.id
      end

      it "does not swap the AvailableUpgrade out when the squad unit isn't associated with the UpgradeSwap" do
        expect(squad_upgrade2.upgrade_id).to eq upgrade1.id
        subject
        expect(squad_upgrade2.reload.upgrade_id).to eq upgrade1.id
      end

      it "recalculates resources" do
        subject
        expect(company.reload.man).to eq ruleset.starting_man - man1 - man2 - man3 - man4
        expect(company.mun).to eq ruleset.starting_mun - mun1 - mun2 - mun3 - mun4
        expect(company.fuel).to eq ruleset.starting_fuel - fuel1 - fuel2 - fuel3 - fuel4
        expect(company.pop).to eq pop1 + pop2 + pop3 + pop4
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current - vp_cost
      end
    end

    context "when upgrades are modified for the company only" do
      let(:add_man) { 100 }
      let(:add_mun) { -25 }
      let(:add_pop) { 1 }
      let(:replace_mun) { 50 }
      let(:replace_uses) { 5 }
      let!(:du_enabled_upgrade) { create :enabled_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset,
                                         man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:du_modified_replace_upgrade) { create :modified_replace_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset,
                                                  mun: replace_mun, uses: replace_uses, priority: 50 }
      let!(:du_modified_add_upgrade) { create :modified_add_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset,
                                              man: add_man, mun: add_mun, pop: add_pop, priority: 60 }
      let!(:available_unit1) { create :base_available_unit, company: company, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1 }
      let!(:squad1) { create :squad, company: company, available_unit: available_unit1 }
      let!(:available_upgrade1) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit1,
                                         man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:squad_upgrade1) { create :squad_upgrade, squad: squad1, available_upgrade: available_upgrade1 }

      before do
        create :restriction_upgrade_unit, restriction_upgrade: du_enabled_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: du_modified_replace_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: du_modified_add_upgrade, unit: unit1
      end

      it "applies modifications to the available upgrade, in order of priority" do
        subject
        expect(available_upgrade1.reload.man).to eq man3 + add_man
        expect(available_upgrade1.mun).to eq replace_mun + add_mun
        expect(available_upgrade1.fuel).to eq fuel3
        expect(available_upgrade1.pop).to eq pop3 + add_pop
        expect(available_upgrade1.uses).to eq replace_uses
      end

      it "recalculates resources" do
        subject
        expect(company.reload.man).to eq ruleset.starting_man - man1 - available_upgrade1.reload.man
        expect(company.mun).to eq ruleset.starting_mun - mun1 - available_upgrade1.mun
        expect(company.fuel).to eq ruleset.starting_fuel - fuel1 - available_upgrade1.fuel
        expect(company.pop).to eq pop1 + available_upgrade1.pop
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

    context "when the company is in a battle" do
      before do
        battle = create :battle, ruleset: ruleset
        create :battle_player, battle: battle, player: company.player, company: company
      end

      it "raises an error" do
        expect { instance.purchase_doctrine_unlock(doctrine_unlock) }.
          to raise_error "Company #{company.id} is in an active battle and cannot be updated"
      end
    end
  end

  describe "#refund_company_unlock" do
    let!(:company_unlock) { create :company_unlock, company: company, doctrine_unlock: doctrine_unlock }

    subject { instance.refund_company_unlock(company_unlock.id) }

    context "when the doctrine unlock only enables units" do
      let!(:du_enabled_unit) { create :enabled_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                      man: man1, mun: mun1, fuel: fuel1, pop: pop1, resupply_max: resupply_max }
      let!(:au) { create :available_unit, company: company, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1, available: resupply_max, resupply_max: resupply_max }
      let!(:squad1) { create :squad, company: company, available_unit: au }
      let!(:squad2) { create :squad, company: company, available_unit: au }
      before do
        company.update!(man: company.man - (au.man * 2), mun: company.mun - (au.mun * 2), fuel: company.fuel - (au.fuel * 2), pop: au.pop * 2)
      end

      it "destroys the available_unit for the enabled unit" do
        expect { subject }.to change { AvailableUnit.count }.by -1
        expect(AvailableUnit.exists?(au.id)).to be false
      end

      it "destroys any squads for the available_unit of the enabled unit" do
        expect { subject }.to change { Squad.count }.by -2
        expect(Squad.exists?(squad1.id)).to be false
        expect(Squad.exists?(squad2.id)).to be false
      end

      it "recalculates resources" do
        subject
        expect(company.reload.man).to eq ruleset.starting_man
        expect(company.reload.mun).to eq ruleset.starting_mun
        expect(company.reload.fuel).to eq ruleset.starting_fuel
        expect(company.reload.pop).to eq 0
      end

      it "refunds the cost for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end

      it "refunds the cost for the Squads" do
        subject
        expect(company.reload.man).to eq starting_man
        expect(company.mun).to eq starting_mun
        expect(company.fuel).to eq starting_fuel
        expect(company.pop).to eq 0
      end
    end

    context "when the doctrine unlock only disables units" do
      let!(:restriction_unit1) { create :enabled_unit, unit: unit1, man: man1, pop: 4, resupply: 4, resupply_max: resupply_max, company_max: 10, restriction: restriction_faction, ruleset: ruleset }
      let!(:du_disabled_unit) { create :disabled_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                       man: man1, resupply_max: resupply_max }

      it "creates an available_unit for the enabled unit" do
        expect { subject }.to change { AvailableUnit.count }.by 1
        new_au = AvailableUnit.last
        expect(new_au.unit_id).to eq unit1.id
        expect(new_au.man).to eq man1
        expect(new_au.resupply_max).to eq resupply_max
      end

      it "doesn't recalculate resources" do
        company_service_double = double
        allow(CompanyService).to receive(:new).and_return company_service_double
        expect(company_service_double).not_to receive(:recalculate_and_update_resources)
        subject
      end

      it "refunds the cost for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end

      it "does not change Company resources" do
        subject
        expect(company.reload.man).to eq starting_man
        expect(company.mun).to eq starting_mun
        expect(company.fuel).to eq starting_fuel
        expect(company.pop).to eq 0
      end
    end

    context "when units are enabled/disabled and swapped" do
      let!(:restriction_unit1) { create :enabled_unit, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1, resupply: 4, resupply_max: resupply_max, company_max: 10, restriction: restriction_faction, ruleset: ruleset }
      let!(:du_disabled_unit) { create :disabled_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                       man: man1, resupply_max: resupply_max }
      let!(:du_enabled_unit) { create :enabled_unit, restriction: du_restriction, unit: unit2, ruleset: ruleset,
                                      man: man1, resupply_max: resupply_max }
      let!(:au2) { create :base_available_unit, company: company, unit: unit2, available: resupply_max }
      let!(:au3) { create :base_available_unit, company: company, unit: unit3, man: man2, mun: mun2, fuel: fuel2, pop: pop2, available: resupply_max }
      let!(:unit_swap) { create :unit_swap, unlock: doctrine_unlock.unlock, old_unit: unit1, new_unit: unit2 }
      let!(:squad1) { create :squad, company: company, available_unit: au2 }
      let!(:squad2) { create :squad, company: company, available_unit: au2 }
      let!(:squad3) { create :squad, company: company, available_unit: au3 }

      it "creates an available_unit for the previously disabled unit" do
        subject
        new_au = AvailableUnit.last
        expect(new_au.unit_id).to eq unit1.id
        expect(new_au.man).to eq man1
        expect(new_au.resupply_max).to eq resupply_max
      end

      it "removes the available_unit for the previously enabled unit" do
        subject
        expect(AvailableUnit.exists?(au2.id)).to be false
        expect(au3.destroyed?).to be false
      end

      it "updates squads containing the previously enabled unit" do
        subject
        new_au = AvailableUnit.last
        expect(squad1.reload.available_unit).to eq new_au
        expect(squad2.reload.available_unit).to eq new_au
        expect(squad3.reload.available_unit).to eq au3
      end

      it "updates the previously disabled unit's available value" do
        subject
        new_au = AvailableUnit.last
        expect(new_au.available).to eq resupply_max - 2
        expect(au3.reload.available).to eq resupply_max
      end

      it "recalculates resources" do
        subject
        expect(company.reload.man).to eq starting_man - (man1 * 2) - man2
        expect(company.mun).to eq starting_mun - (mun1 * 2) - mun2
        expect(company.fuel).to eq starting_fuel - (fuel1 * 2) - fuel2
        expect(company.pop).to eq pop1 * 2 + pop2
      end

      it "refunds the cost of the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end
    end

    context "when units are modified for the company only" do
      let!(:company_unlock2) { create :company_unlock, company: company, doctrine_unlock: doctrine_unlock2 }
      let(:add_man) { 100 }
      let(:add_fuel) { 25 }
      let(:add_pop) { -1 }
      let(:replace_fuel) { 0 }
      let(:replace_resupply) { 5 }
      let!(:doc_enabled_unit) { create :enabled_unit, restriction: restriction_doctrine, unit: unit1, ruleset: ruleset,
                                       man: man1, mun: mun1, fuel: fuel1, pop: pop1, resupply: resupply_max, resupply_max: resupply_max }
      let!(:au) { create :base_available_unit, company: company, unit: unit1, man: man1 + add_man, mun: mun1, fuel: replace_fuel + add_fuel, pop: pop1 + add_pop,
                         resupply: replace_resupply, resupply_max: resupply_max }

      let!(:du_modified_replace_unit) { create :modified_replace_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                               fuel: replace_fuel, resupply: replace_resupply, priority: 50 }
      let!(:du_modified_add_unit) { create :modified_add_unit, restriction: du_restriction2, unit: unit1, ruleset: ruleset,
                                           man: add_man, fuel: add_fuel, pop: add_pop, priority: 60 }

      let!(:squad1) { create :squad, company: company, available_unit: au }
      let!(:squad2) { create :squad, company: company, available_unit: au }

      before do
        company.update!(man: company.man - (au.man * 2), mun: company.mun - (au.mun * 2), fuel: company.fuel - (au.fuel * 2), pop: au.pop * 2)
      end

      it "removes the modification but reapplies all other modifications not being removed" do
        subject
        expect(au.reload.man).to eq man1 + add_man
        expect(au.mun).to eq mun1
        expect(au.fuel).to eq fuel1 + add_fuel
        expect(au.pop).to eq pop1 + add_pop
        expect(au.resupply).to eq resupply_max
        expect(au.resupply_max).to eq resupply_max
      end

      it "recalculates the cost for the Squads" do
        subject
        expect(company.reload.man).to eq starting_man - (au.reload.man * 2)
        expect(company.mun).to eq starting_mun - (au.mun * 2)
        expect(company.fuel).to eq starting_fuel - (au.fuel * 2)
        expect(company.pop).to eq au.pop * 2
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end
    end

    context "when the doctrine unlock enables an offmap" do
      let!(:du_enabled_offmap) { create :enabled_offmap, restriction: du_restriction, offmap: offmap1, ruleset: ruleset, mun: 120, max: 2 }
      let!(:ao) { create :available_offmap, company: company, offmap: offmap1, mun: 120, max: 3, available: 0 }
      let!(:company_offmap1) { create :company_offmap, company: company, available_offmap: ao }
      let!(:company_offmap2) { create :company_offmap, company: company, available_offmap: ao }
      let!(:company_offmap3) { create :company_offmap, company: company, available_offmap: ao }

      before do
        company.update!(mun: starting_mun - (ao.mun * 3))
      end

      it "destroys the AvailableOffmap for the enabled offmap" do
        expect { subject }.to change { AvailableOffmap.count }.by -1
        expect(AvailableOffmap.exists?(ao.id)).to be false
      end

      it "destroys any CompanyOffmaps for the AvailableOffmap of the enabled offmap" do
        expect { subject }.to change { CompanyOffmap.count }.by -3
        expect(CompanyOffmap.exists?(company_offmap1.id)).to be false
        expect(CompanyOffmap.exists?(company_offmap2.id)).to be false
        expect(CompanyOffmap.exists?(company_offmap3.id)).to be false
      end

      it "refunds the cost for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end

      it "refunds the cost for the CompanyOffmaps" do
        subject
        expect(company.reload.mun).to eq starting_mun
      end
    end

    context "when the doctrine unlock enables an callin modifier" do
      let!(:du_enabled_callin_modifier) { create :enabled_callin_modifier, restriction: du_restriction, callin_modifier: callin_modifier, ruleset: ruleset }
      let!(:ccm) { create :company_callin_modifier, company: company, callin_modifier: callin_modifier }

      it "destroys the CompanyCallinModifier for the enabled offmap" do
        expect { subject }.to change { CompanyCallinModifier.count }.by -1
        expect(CompanyCallinModifier.exists?(ccm.id)).to be false
      end

      it "refunds the cost for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end
    end

    context "when the doctrine unlock only enables upgrades" do
      let!(:du_enabled_upgrade) { create :enabled_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset,
                                         man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:available_upgrade1) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit1 }
      let!(:available_upgrade2) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit2 }
      let!(:available_unit1) { create :base_available_unit, company: company, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1 }
      let!(:available_unit2) { create :base_available_unit, company: company, unit: unit2, man: man2, mun: mun2, fuel: fuel2, pop: pop2 }
      let!(:squad1) { create :squad, available_unit: available_unit1, company: company }
      let!(:squad2) { create :squad, available_unit: available_unit2, company: company }
      let!(:squad_upgrade1) { create :squad_upgrade, squad: squad1, available_upgrade: available_upgrade1 }
      let!(:squad_upgrade2) { create :squad_upgrade, squad: squad2, available_upgrade: available_upgrade2 }

      before do
        create :restriction_upgrade_unit, restriction_upgrade: du_enabled_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: du_enabled_upgrade, unit: unit2
      end

      it "removes the AvailableUpgrades for the enabled_upgrade" do
        expect { subject }.to change { AvailableUpgrade.count }.by -2
        expect(AvailableUpgrade.exists?(available_upgrade1.id)).to be false
        expect(AvailableUpgrade.exists?(available_upgrade2.id)).to be false
      end

      it "removes the SquadUpgrades for the enabled_upgrade" do
        expect { subject }.to change { SquadUpgrade.count }.by -2
        expect(SquadUpgrade.exists?(squad_upgrade1.id)).to be false
        expect(SquadUpgrade.exists?(squad_upgrade2.id)).to be false
      end

      it "recalculates resources" do
        subject
        expect(company.reload.man).to eq ruleset.starting_man - man1 - man2
        expect(company.reload.mun).to eq ruleset.starting_mun - mun1 - mun2
        expect(company.reload.fuel).to eq ruleset.starting_fuel - fuel1 - fuel2
        expect(company.reload.pop).to eq pop1 + pop2
      end

      it "refunds the cost for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end
    end

    context "when the doctrine unlock only disables upgrades" do
      let!(:doc_enabled_upgrade) { create :enabled_upgrade, restriction: restriction_doctrine, upgrade: upgrade1, ruleset: ruleset,
                                          man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:du_disabled_upgrade) { create :disabled_upgrade, upgrade: upgrade1, restriction: du_restriction, ruleset: ruleset }

      before do
        create :restriction_upgrade_unit, restriction_upgrade: doc_enabled_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: doc_enabled_upgrade, unit: unit2
        create :restriction_upgrade_unit, restriction_upgrade: du_disabled_upgrade, unit: unit1
      end

      it "creates BaseAvailableUpgrade for the upgrade/unit combination enabled by the faction/doctrine that was previously disabled" do
        expect { subject }.to change { BaseAvailableUpgrade.count }.by 1
        bau = BaseAvailableUpgrade.last
        expect(bau.upgrade_id).to eq upgrade1.id
        expect(bau.unit_id).to eq unit1.id
        expect(bau.company).to eq company
        expect(bau.man).to eq man3
        expect(bau.mun).to eq mun3
        expect(bau.fuel).to eq fuel3
        expect(bau.pop).to eq pop3
        expect(bau.uses).to eq uses3
      end

      it "doesn't recalculate resources" do
        company_service_double = double
        allow(CompanyService).to receive(:new).and_return company_service_double
        expect(company_service_double).not_to receive(:recalculate_and_update_resources)
        subject
      end

      it "refunds the cost for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end
    end

    context "when upgrades are swapped only" do
      let!(:doc_enabled_upgrade1) { create :enabled_upgrade, restriction: restriction_doctrine, upgrade: upgrade1, ruleset: ruleset,
                                           man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:doc_enabled_upgrade2) { create :enabled_upgrade, restriction: restriction_doctrine, upgrade: upgrade2, ruleset: ruleset,
                                           man: man4, mun: mun4, fuel: fuel4, pop: pop4, uses: uses4 }
      let!(:upgrade_swap) { create :upgrade_swap, unlock: unlock1, old_upgrade: upgrade1, new_upgrade: upgrade2 }
      let!(:available_upgrade1) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit1, man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:available_upgrade2) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit2, man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:available_upgrade3) { create :base_available_upgrade, company: company, upgrade: upgrade2, unit: unit1, man: man4, mun: mun4, fuel: fuel4, pop: pop4, uses: uses4 }
      let!(:available_upgrade4) { create :base_available_upgrade, company: company, upgrade: upgrade2, unit: unit2, man: man4, mun: mun4, fuel: fuel4, pop: pop4, uses: uses4 }
      let!(:available_unit1) { create :base_available_unit, company: company, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1 }
      let!(:available_unit2) { create :base_available_unit, company: company, unit: unit2, man: man2, mun: mun2, fuel: fuel2, pop: pop2 }
      let!(:squad1) { create :squad, available_unit: available_unit1, company: company }
      let!(:squad2) { create :squad, available_unit: available_unit2, company: company }
      let!(:squad_upgrade1) { create :squad_upgrade, squad: squad1, available_upgrade: available_upgrade3 }
      let!(:squad_upgrade2) { create :squad_upgrade, squad: squad2, available_upgrade: available_upgrade4 }

      before do
        create :restriction_upgrade_unit, restriction_upgrade: doc_enabled_upgrade1, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: doc_enabled_upgrade1, unit: unit2
        create :restriction_upgrade_unit, restriction_upgrade: doc_enabled_upgrade2, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: doc_enabled_upgrade2, unit: unit2
        create :upgrade_swap_unit, upgrade_swap: upgrade_swap, unit: unit2
      end

      it "does not change BaseAvailableUpgrades" do
        expect { subject }.not_to change { BaseAvailableUpgrade.count }
        expect(AvailableUpgrade.exists?(available_upgrade1.id)).to be true
        expect(AvailableUpgrade.exists?(available_upgrade2.id)).to be true
      end

      it "swaps the upgrade in the SquadUpgrade" do
        expect(squad_upgrade2.available_upgrade_id).to eq available_upgrade4.id
        expect { subject }.not_to change { SquadUpgrade.count }
        expect(squad_upgrade2.reload.available_upgrade_id).to eq available_upgrade2.id
      end

      it "doesn't swap the AvailableUpgrade when the squad's unit is not associated with the upgrade swap" do
        expect(squad_upgrade1.available_upgrade_id).to eq available_upgrade3.id
        subject
        expect(squad_upgrade1.reload.available_upgrade_id).to eq available_upgrade3.id
      end

      it "recalculates resources" do
        subject
        expect(company.reload.man).to eq starting_man - man1 - man2 - man3 - man4
        expect(company.mun).to eq starting_mun - mun1 - mun2 - mun3 - mun4
        expect(company.fuel).to eq starting_fuel - fuel1 - fuel2 - fuel3 - fuel4
        expect(company.pop).to eq pop1 + pop2 + pop3 + pop4
      end

      it "refunds the cost of the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end

      context "when there isn't a BaseAvailableUpgrade for the old upgrade and unit" do
        before do
          BaseAvailableUpgrade.find_by!(company: company, upgrade: upgrade1, unit: unit2).destroy!
        end
        it "does not alter the SquadUpgrade" do
          expect(squad_upgrade2.available_upgrade_id).to eq available_upgrade4.id
          expect { subject }.to change { SquadUpgrade.count }.by 0
          expect(squad_upgrade2.reload.available_upgrade_id).to eq available_upgrade4.id
        end
      end

      context "when only 1 of the units is eligible to be swapped" do
        # TODO UpgradeSwapUnit
      end
    end

    context "when upgrades are enabled/disabled and swapped" do
      let!(:doc_enabled_upgrade) { create :enabled_upgrade, restriction: restriction_doctrine, upgrade: upgrade1, ruleset: ruleset,
                                          man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:du_disabled_upgrade) { create :disabled_upgrade, upgrade: upgrade1, restriction: du_restriction, ruleset: ruleset }
      let!(:du_enabled_upgrade) { create :enabled_upgrade, restriction: du_restriction, upgrade: upgrade2, ruleset: ruleset,
                                         man: man4, mun: mun4, fuel: fuel4, pop: pop4, uses: uses4 }
      let!(:upgrade_swap) { create :upgrade_swap, unlock: unlock1, old_upgrade: upgrade1, new_upgrade: upgrade2 }
      let!(:available_upgrade1) { create :base_available_upgrade, company: company, upgrade: upgrade2, unit: unit1, man: man4, mun: mun4, fuel: fuel4, pop: pop4, uses: uses4 }
      let!(:available_upgrade2) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit2, man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:available_unit1) { create :base_available_unit, company: company, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1 }
      let!(:available_unit2) { create :base_available_unit, company: company, unit: unit2, man: man2, mun: mun2, fuel: fuel2, pop: pop2 }
      let!(:squad1) { create :squad, available_unit: available_unit1, company: company }
      let!(:squad2) { create :squad, available_unit: available_unit2, company: company }
      let!(:squad_upgrade1) { create :squad_upgrade, squad: squad1, available_upgrade: available_upgrade1 }
      let!(:squad_upgrade2) { create :squad_upgrade, squad: squad2, available_upgrade: available_upgrade2 }

      before do
        create :restriction_upgrade_unit, restriction_upgrade: doc_enabled_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: doc_enabled_upgrade, unit: unit2
        create :restriction_upgrade_unit, restriction_upgrade: du_disabled_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: du_enabled_upgrade, unit: unit1
        create :upgrade_swap_unit, upgrade_swap: upgrade_swap, unit: unit1
      end

      it "creates BaseAvailableUpgrades for the previously disabled upgrade/unit" do
        expect { subject }.to change { BaseAvailableUpgrade.count }.by 0 # -1 + 1
        bau = BaseAvailableUpgrade.last
        expect(bau.upgrade_id).to eq upgrade1.id
        expect(bau.unit_id).to eq unit1.id
        expect(bau.company).to eq company
        expect(bau.man).to eq man3
        expect(bau.mun).to eq mun3
        expect(bau.fuel).to eq fuel3
        expect(bau.pop).to eq pop3
        expect(bau.uses).to eq uses3
      end

      it "removes the BaseAvailableUpgrade for the previously enabled upgrade/unit" do
        subject
        expect(BaseAvailableUpgrade.exists?(available_upgrade1.id)).to be false
        expect(BaseAvailableUpgrade.exists?(available_upgrade2.id)).to be true
      end

      it "updates SquadUpgrades containing the previously enabled upgrade for the new upgrade" do
        expect(squad_upgrade1.upgrade_id).to eq upgrade2.id
        expect { subject }.to change { SquadUpgrade.count }.by 0 # Does not remove any
        expect(squad_upgrade1.reload.upgrade_id).to eq upgrade1.id
      end

      it "does not change units that aren't associated with the restriction upgrade" do
        subject
        expect(BaseAvailableUpgrade.exists?(available_upgrade2.id)).to be true
        expect(SquadUpgrade.exists?(squad_upgrade2.id)).to be true
      end

      it "recalculates resources" do
        subject
        expect(company.reload.man).to eq starting_man - man1 - man2 - 2 * man3
        expect(company.mun).to eq starting_mun - mun1 - mun2 - 2 * mun3
        expect(company.fuel).to eq starting_fuel - fuel1 - fuel2 - 2 * fuel3
        expect(company.pop).to eq pop1 + pop2 + 2 * fuel3
      end

      it "refunds the cost of the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end
    end

    context "when upgrades are modified for the company only" do
      let(:add_man) { 100 }
      let(:add_mun) { -25 }
      let(:add_pop) { 1 }
      let(:replace_mun) { 50 }
      let(:replace_uses) { 5 }
      let!(:doc_enabled_upgrade) { create :enabled_upgrade, restriction: restriction_doctrine, upgrade: upgrade1, ruleset: ruleset,
                                          man: man3, mun: mun3, fuel: fuel3, pop: pop3, uses: uses3 }
      let!(:company_unlock2) { create :company_unlock, company: company, doctrine_unlock: doctrine_unlock2 }
      let!(:du_modified_replace_upgrade) { create :modified_replace_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset,
                                                  mun: replace_mun, uses: replace_uses, priority: 50 }
      let!(:du_modified_add_upgrade) { create :modified_add_upgrade, restriction: du_restriction2, upgrade: upgrade1, ruleset: ruleset,
                                              man: add_man, mun: add_mun, pop: add_pop, priority: 60 }
      let!(:available_unit1) { create :base_available_unit, company: company, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1 }
      let!(:squad1) { create :squad, company: company, available_unit: available_unit1 }
      let!(:available_upgrade1) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit1,
                                         man: man3 + add_man, mun: replace_mun + add_mun, fuel: fuel3, pop: pop3 + add_pop, uses: replace_uses }
      let!(:squad_upgrade1) { create :squad_upgrade, squad: squad1, available_upgrade: available_upgrade1 }

      before do
        create :restriction_upgrade_unit, restriction_upgrade: doc_enabled_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: du_modified_replace_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: du_modified_add_upgrade, unit: unit1
      end

      it "removes the modification but reapplies all other modifications not being removed" do
        expect(available_upgrade1.man).to eq man3 + add_man
        expect(available_upgrade1.mun).to eq replace_mun + add_mun
        expect(available_upgrade1.fuel).to eq fuel3
        expect(available_upgrade1.pop).to eq pop3 + add_pop
        expect(available_upgrade1.uses).to eq replace_uses
        subject
        expect(available_upgrade1.reload.man).to eq man3 + add_man
        expect(available_upgrade1.mun).to eq mun3 + add_mun
        expect(available_upgrade1.fuel).to eq fuel3
        expect(available_upgrade1.pop).to eq pop3 + add_pop
        expect(available_upgrade1.uses).to eq uses3
      end

      it "recalculates company resources" do
        subject
        expect(company.reload.man).to eq starting_man - man1 - available_upgrade1.reload.man
        expect(company.mun).to eq starting_mun - mun1 - available_upgrade1.mun
        expect(company.fuel).to eq starting_fuel - fuel1 - available_upgrade1.fuel
        expect(company.pop).to eq pop1 + available_upgrade1.pop
      end

      it "pays for the company unlock" do
        subject
        expect(company.reload.vps_current).to eq vps_current + vp_cost
      end
    end

    context "when the company doesn't own the given company_unlock_id" do
      let!(:company2) { create :active_company, ruleset: ruleset }
      let!(:company_unlock) { create :company_unlock, company: company2, doctrine_unlock: doctrine_unlock }

      it "raises an error" do
        expect { subject }.to raise_error "Company #{company.id} does not have a company_unlock with id #{company_unlock.id}"
      end
    end

    context "when the company is in a battle" do
      before do
        battle = create :battle, ruleset: ruleset
        create :battle_player, battle: battle, player: company.player, company: company
      end

      it "raises an error" do
        expect { subject }.
          to raise_error "Company #{company.id} is in an active battle and cannot be updated"
      end
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

      context "when the old unit is disabled" do
        before do
          unit1.update!(disabled: true)
        end

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

      context "when the new unit is disabled" do
        before do
          unit2.update!(disabled: true)
        end

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

    context "when reverse is true" do
      context "when there are squads containing new units" do
        let!(:squad1) { create :squad, company: company, available_unit: au3 }
        let!(:squad2) { create :squad, company: company, available_unit: au3 }
        let!(:squad3) { create :squad, company: company, available_unit: au2 }
        let!(:squad4) { create :squad, company: company, available_unit: au2 }

        it "updates squads containing the new unit" do
          instance.send(:swap_squad_units, [squad1, squad2, squad3, squad4], [unit_swap], reverse: true)
          expect(squad1.reload.available_unit).to eq au1
          expect(squad2.reload.available_unit).to eq au1
          expect(squad3.reload.available_unit).to eq au2
          expect(squad4.reload.available_unit).to eq au2
        end

        it "updates the old unit's available value" do
          instance.send(:swap_squad_units, [squad1, squad2, squad3, squad4], [unit_swap], reverse: true)
          expect(au1.reload.available).to eq default_available - 2
          expect(au2.reload.available).to eq default_available
          expect(au3.reload.available).to eq new_unit_available
        end

        context "when the old unit is disabled" do
          before do
            unit1.update!(disabled: true)
          end

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

        context "when the new unit is disabled" do
          before do
            unit2.update!(disabled: true)
          end

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
      end

      context "when there are no squads containing new units" do
        let!(:squad3) { create :squad, company: company, available_unit: au2 }
        let!(:squad4) { create :squad, company: company, available_unit: au2 }

        it "does not change the existing squads" do
          instance.send(:swap_squad_units, [squad3, squad4], [unit_swap], reverse: true)
          expect(squad3.reload.available_unit).to eq au2
          expect(squad4.reload.available_unit).to eq au2
        end

        it "does not change the old unit's available value" do
          instance.send(:swap_squad_units, [squad3, squad4], [unit_swap], reverse: true)
          expect(au1.reload.available).to eq default_available
          expect(au2.reload.available).to eq default_available
          expect(au3.reload.available).to eq new_unit_available
        end
      end

      context "when the old unit to swap to is not available for the company" do
        let!(:au1) { nil }
        let!(:squad1) { create :squad, company: company, available_unit: au3 }
        let!(:squad2) { create :squad, company: company, available_unit: au3 }
        let!(:squad3) { create :squad, company: company, available_unit: au2 }
        let!(:squad4) { create :squad, company: company, available_unit: au2 }

        it "does not update squads containing the old unit" do
          instance.send(:swap_squad_units, [squad1, squad2, squad3, squad4], [unit_swap], reverse: true)
          expect(squad1.reload.available_unit).to eq au3
          expect(squad2.reload.available_unit).to eq au3
          expect(squad3.reload.available_unit).to eq au2
          expect(squad4.reload.available_unit).to eq au2
        end
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

  describe "#refund_cost_for_company_unlock" do
    let!(:company_unlock) { create :company_unlock, doctrine_unlock: doctrine_unlock, company: company }

    it "updates the Company's vps_current to refund the DoctrineUnlock" do
      instance.send(:refund_cost_for_company_unlock, company_unlock)
      expect(company.reload.vps_current).to eq vps_current + vp_cost
    end

    it "destroys the CompanyUnlock" do
      expect { instance.send(:refund_cost_for_company_unlock, company_unlock) }.to change { CompanyUnlock.count }.by -1
      expect(CompanyUnlock.exists?(company_unlock.id)).to be false
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

  describe "#validate_purchased" do
    it "passes when the company has a company_unlock matching the given company_unlock_id" do
      company_unlock = create :company_unlock, company: company, doctrine_unlock: doctrine_unlock
      expect { instance.send(:validate_purchased, company_unlock.id) }.not_to raise_error
    end

    it "fails when the company does not have a company_unlock for the given id" do
      expect { instance.send(:validate_purchased, 1234) }.
        to raise_error "Company #{company.id} does not have a company_unlock with id #{1234}"
    end
  end
end
