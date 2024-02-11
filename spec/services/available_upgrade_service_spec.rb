require "rails_helper"

RSpec.describe AvailableUpgradeService do
  let!(:player) { create :player }
  let!(:ruleset) { create :ruleset }
  let(:faction) { create :faction }
  let(:faction2) { create :faction }
  let(:doctrine1) { create :doctrine, faction: faction }
  let(:doctrine2) { create :doctrine, faction: faction }
  let(:doctrine) { doctrine1 }
  let!(:company) { create :active_company, faction: faction, doctrine: doctrine, ruleset: ruleset }
  let!(:restriction_faction) { create :restriction, faction: faction, doctrine: nil, unlock: nil, description: "for faction #{faction.id}" }
  let!(:restriction_faction2) { create :restriction, faction: faction2, doctrine: nil, unlock: nil, description: "for faction #{faction2.id}" }
  let!(:restriction_doctrine1) { create :restriction, faction: nil, doctrine: doctrine1, unlock: nil, name: "doctrine1 level", description: "for doctrine #{doctrine1.id}" }
  let!(:restriction_doctrine2) { create :restriction, faction: nil, doctrine: doctrine2, unlock: nil, name: "doctrine2 level", description: "for doctrine #{doctrine2.id}" }
  let!(:upgrade1) { create :upgrade }
  let!(:upgrade2) { create :upgrade }
  let!(:upgrade3) { create :upgrade }
  let!(:upgrade4) { create :upgrade }
  let!(:enabled_upgrade1) { create :enabled_upgrade, upgrade: upgrade1, man: 0, mun: 35, fuel: 0, pop: 0, uses: 2, restriction: restriction_faction, ruleset: ruleset }
  let!(:enabled_upgrade1_doctrine) { create :enabled_upgrade, upgrade: upgrade1, man: 0, mun: 40, fuel: 0, pop: 0, uses: 3, restriction: restriction_doctrine1, ruleset: ruleset }
  let!(:enabled_upgrade2) { create :enabled_upgrade, upgrade: upgrade2, man: 100, mun: 35, fuel: 0, pop: 2, uses: 0, restriction: restriction_faction, ruleset: ruleset }
  let!(:enabled_upgrade3) { create :enabled_upgrade, upgrade: upgrade3, man: 0, mun: 0, fuel: 50, pop: 0, uses: 0, restriction: restriction_doctrine1, ruleset: ruleset }
  let!(:enabled_upgrade4) { create :enabled_upgrade, upgrade: upgrade4, restriction: restriction_faction2, ruleset: ruleset }
  let!(:disabled_upgrade2) { create :disabled_upgrade, upgrade: upgrade2, restriction: restriction_doctrine2, ruleset: ruleset }

  let!(:unit1) { create :unit }
  let!(:unit2) { create :unit }
  let!(:unit3) { create :unit }
  let!(:unit4) { create :unit }
  let!(:available_unit1) { create :available_unit, unit: unit1, company: company }
  let!(:available_unit2) { create :available_unit, unit: unit2, company: company }
  let!(:available_unit3) { create :available_unit, unit: unit3, company: company }
  let!(:available_unit4) { create :available_unit, unit: unit4, company: company }

  let(:instance) { described_class.new(company) }

  before do
    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade1, unit: unit1
    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade1, unit: unit2
    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade1_doctrine, unit: unit1

    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade2, unit: unit2
    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade2, unit: unit3

    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade3, unit: unit3

    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade4, unit: unit4

    create :restriction_upgrade_unit, restriction_upgrade: disabled_upgrade2, unit: unit2
  end

  describe "#build_new_company_available_upgrades" do
    subject { instance.build_new_company_available_upgrades }

    it "creates the correct number of AvailableUpgrades" do
      expect { subject }.to change { AvailableUpgrade.count }.by 5

      available_upgrades = AvailableUpgrade.where(company: company)
      expect(available_upgrades.count).to eq 5
      expect(available_upgrades.pluck(:upgrade_id))
        .to match_array [upgrade1.id, upgrade1.id, upgrade2.id, upgrade2.id, upgrade3.id]
    end

    it "creates the correct AvailableUpgrades for upgrade1" do
      subject
      au1 = AvailableUpgrade.find_by(company: company, upgrade: upgrade1, unit: unit1)
      expect(au1.pop).to eq 0
      expect(au1.man).to eq 0
      expect(au1.mun).to eq 40
      expect(au1.fuel).to eq 0
      expect(au1.uses).to eq 3
      au2 = AvailableUpgrade.find_by(company: company, upgrade: upgrade1, unit: unit2)
      expect(au2.pop).to eq 0
      expect(au2.man).to eq 0
      expect(au2.mun).to eq 35
      expect(au2.fuel).to eq 0
      expect(au2.uses).to eq 2
    end

    it "creates the correct AvailableUpgrades for upgrade2" do
      subject
      au1 = AvailableUpgrade.find_by(company: company, upgrade: upgrade2, unit: unit2)
      expect(au1.pop).to eq 2
      expect(au1.man).to eq 100
      expect(au1.mun).to eq 35
      expect(au1.fuel).to eq 0
      expect(au1.uses).to eq 0
      au2 = AvailableUpgrade.find_by(company: company, upgrade: upgrade2, unit: unit3)
      expect(au2.pop).to eq 2
      expect(au2.man).to eq 100
      expect(au2.mun).to eq 35
      expect(au2.fuel).to eq 0
      expect(au2.uses).to eq 0
    end

    it "creates the correct AvailableUpgrades for upgrade3" do
      subject
      au1 = AvailableUpgrade.find_by(company: company, upgrade: upgrade3, unit: unit3)
      expect(au1.pop).to eq 0
      expect(au1.man).to eq 0
      expect(au1.mun).to eq 0
      expect(au1.fuel).to eq 50
      expect(au1.uses).to eq 0
    end

  end

  describe "#add_enabled_available_upgrades" do
    let(:enabled_upgrades) { [enabled_upgrade1, enabled_upgrade2] }

    subject { instance.add_enabled_available_upgrades(enabled_upgrades) }

    it "creates available upgrades" do
      expect { subject }.to change { AvailableUpgrade.count }.by 4
      au1 = AvailableUpgrade.find_by(upgrade: upgrade1, unit: unit1, company: company)
      expect(au1.man).to eq 0
      expect(au1.mun).to eq 35
      expect(au1.fuel).to eq 0
      expect(au1.pop).to eq 0
      expect(au1.uses).to eq 2
      au2 = AvailableUpgrade.find_by(upgrade: upgrade1, unit: unit2, company: company)
      expect(au2.man).to eq 0
      expect(au2.mun).to eq 35
      expect(au2.fuel).to eq 0
      expect(au2.pop).to eq 0
      expect(au2.uses).to eq 2
      au3 = AvailableUpgrade.find_by(upgrade: upgrade2, unit: unit2, company: company)
      expect(au3.man).to eq 100
      expect(au3.mun).to eq 35
      expect(au3.fuel).to eq 0
      expect(au3.pop).to eq 2
      expect(au3.uses).to eq 0
      au4 = AvailableUpgrade.find_by(upgrade: upgrade2, unit: unit3, company: company)
      expect(au4.man).to eq 100
      expect(au4.mun).to eq 35
      expect(au4.fuel).to eq 0
      expect(au4.pop).to eq 2
      expect(au4.uses).to eq 0
    end

    context "when there is a conflicting BaseAvailableUpgrade" do
      let(:enabled_upgrades) { [enabled_upgrade1] }
      let!(:existing_au) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit1, man: 0, mun: 100, fuel: 0, pop: 0, uses: 2 }

      it "overwrites the existing BaseAvailableUpgrade" do
        expect { subject }.to change { AvailableUpgrade.count }.by 1
        existing_au.reload
        expect(existing_au.mun).to eq 35
        au2 = AvailableUpgrade.find_by(upgrade: upgrade1, unit: unit2, company: company)
        expect(au2.man).to eq 0
        expect(au2.mun).to eq 35
        expect(au2.fuel).to eq 0
        expect(au2.pop).to eq 0
        expect(au2.uses).to eq 2
      end
    end
  end

  describe "#recreate_disabled_from_doctrine_unlock" do
    let!(:ruleset) { create :ruleset }
    let!(:company) { create :active_company, faction: faction, doctrine: doctrine1, ruleset: ruleset }
    let!(:doctrine_unlock) { create :doctrine_unlock, doctrine: doctrine1, ruleset: ruleset }
    let(:du_restriction) { doctrine_unlock.restriction }
    let!(:enabled_upgrade) { create :enabled_upgrade, upgrade: upgrade4, man: 100, mun: 100, fuel: 100, pop: 0, uses: 0, restriction: restriction_doctrine1, ruleset: ruleset }
    let!(:disabled_upgrade) { create :disabled_upgrade, upgrade: upgrade4, restriction: du_restriction, ruleset: ruleset }
    let(:previously_disabled_upgrades) { [disabled_upgrade] }
    before do
      create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade, unit: unit1
      create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade, unit: unit2
      create :restriction_upgrade_unit, restriction_upgrade: disabled_upgrade, unit: unit1
    end

    subject { instance.recreate_disabled_from_doctrine_unlock(previously_disabled_upgrades, doctrine_unlock) }

    context "when the available upgrades should come from the faction/doctrine base set" do
      it "creates BaseAvailableUpgrade for the upgrade/unit combination enabled by the faction & doctrine that was previously disabled" do
        expect { subject }.to change { BaseAvailableUpgrade.count }.by 1
        au = BaseAvailableUpgrade.last
        expect(au.upgrade_id).to eq upgrade4.id
        expect(au.unit_id).to eq unit1.id
        expect(au.company).to eq company
        expect(au.man).to eq 100
        expect(au.mun).to eq 100
        expect(au.fuel).to eq 100
        expect(au.pop).to eq 0
        expect(au.uses).to eq 0
      end
    end

    context "when the available upgrades are also affected by a doctrine unlock enabling one" do
      # This is a rare case because its not desirable to have multiple doctrine unlocks enabling the same upgrade/unit
      # The current logic will overwrite the MODIFY_FIELD values with those of the most recent enabled_upgrade
      before do
        # Create doctrine unlock that enables the other enabled upgrade
        doctrine_unlock2 = create :doctrine_unlock, doctrine: doctrine1, branch: 2, ruleset: ruleset
        restriction_du2 = create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock2
        doctrine_unlock2.update!(restriction: restriction_du2)
        enabled_upgrade = create :enabled_upgrade, upgrade: upgrade4, man: 200, mun: 200, fuel: 200, pop: 0, uses: 0, restriction: restriction_du2, ruleset: ruleset
        create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade, unit: unit1
        create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade, unit: unit2
        create :company_unlock, company: company, doctrine_unlock: doctrine_unlock2
      end

      it "creates BaseAvailableUpgrade for the upgrade/unit combination enabled by the faction&doctrine, then overwritten by other doctrine unlock" do
        expect { subject }.to change { BaseAvailableUpgrade.count }.by 1
        au = BaseAvailableUpgrade.last
        expect(au.upgrade_id).to eq upgrade4.id
        expect(au.unit_id).to eq unit1.id
        expect(au.company).to eq company
        expect(au.man).to eq 200
        expect(au.mun).to eq 200
        expect(au.fuel).to eq 200
        expect(au.pop).to eq 0
        expect(au.uses).to eq 0
      end

      context "when there is also a doctrine_unlock that disables the upgrade/unit" do
        before do
          doctrine_unlock3 = create :doctrine_unlock, doctrine: doctrine1, branch: 3, ruleset: ruleset
          restriction_du3 = create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock3
          doctrine_unlock3.update!(restriction: restriction_du3)
          disabled_upgrade = create :disabled_upgrade, upgrade: upgrade4, restriction: restriction_du3, ruleset: ruleset
          create :restriction_upgrade_unit, restriction_upgrade: disabled_upgrade, unit: unit1 # this causes upgrade4/unit1 still to be disabled
          create :company_unlock, company: company, doctrine_unlock: doctrine_unlock3
        end

        it "does not create a BaseAvailableUpgrade for the upgrade/unit combination as another disabled_upgrade is still active" do
          expect { subject }.not_to change { BaseAvailableUpgrade }
        end

        context "with another unit associated with the upgrade" do
          before do
            create :restriction_upgrade_unit, restriction_upgrade: disabled_upgrade, unit: unit2 # expect this will be enabled
          end

          it "enables unit2 but not unit1" do
            expect { subject }.to change { BaseAvailableUpgrade.count }.by 1
            au = BaseAvailableUpgrade.last
            expect(au.upgrade_id).to eq upgrade4.id
            expect(au.unit_id).to eq unit2.id
            expect(au.company).to eq company
            expect(au.man).to eq 200
            expect(au.mun).to eq 200
            expect(au.fuel).to eq 200
            expect(au.pop).to eq 0
            expect(au.uses).to eq 0
          end
        end
      end
    end

    context "when the available upgrades is affected by a doctrine unlock disabling the upgrade/unit" do
      before do
        doctrine_unlock3 = create :doctrine_unlock, doctrine: doctrine1, branch: 3, ruleset: ruleset
        restriction_du3 = create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock3
        doctrine_unlock3.update!(restriction: restriction_du3)
        disabled_upgrade = create :disabled_upgrade, upgrade: upgrade4, restriction: restriction_du3, ruleset: ruleset
        create :restriction_upgrade_unit, restriction_upgrade: disabled_upgrade, unit: unit1 # this causes upgrade4/unit1 still to be disabled
        create :company_unlock, company: company, doctrine_unlock: doctrine_unlock3
      end

      it "does not create a BaseAvailableUpgrade for the upgrade/unit combination as another disabled_upgrade is still active" do
        expect { subject }.not_to change { BaseAvailableUpgrade }
      end

      context "with another unit associated with the upgrade" do
        before do
          create :restriction_upgrade_unit, restriction_upgrade: disabled_upgrade, unit: unit2 # expect this will be enabled
        end

        it "enables unit2 but not unit1" do
          expect { subject }.to change { BaseAvailableUpgrade.count }.by 1
          au = BaseAvailableUpgrade.last
          expect(au.upgrade_id).to eq upgrade4.id
          expect(au.unit_id).to eq unit2.id
          expect(au.company).to eq company
          expect(au.man).to eq 100
          expect(au.mun).to eq 100
          expect(au.fuel).to eq 100
          expect(au.pop).to eq 0
          expect(au.uses).to eq 0
        end
      end
    end
  end

  describe "#remove_available_upgrades" do
    let!(:available_upgrade1) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit1 }
    let!(:available_upgrade2) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit2 }
    let!(:available_upgrade3) { create :base_available_upgrade, company: company, upgrade: upgrade2, unit: unit2 }
    let!(:available_upgrade4) { create :base_available_upgrade, company: company, upgrade: upgrade2, unit: unit3 }
    let(:disabled_upgrades) { [disabled_upgrade2] } # upgrade2/unit2
    let!(:squad1) { create :squad, available_unit: available_unit1, company: company }
    let!(:squad2) { create :squad, available_unit: available_unit2, company: company }
    let!(:squad3) { create :squad, available_unit: available_unit3, company: company }
    let!(:squad_upgrade1) { create :squad_upgrade, squad: squad2, available_upgrade: available_upgrade2 }
    let!(:squad_upgrade2) { create :squad_upgrade, squad: squad2, available_upgrade: available_upgrade3 }
    let!(:squad_upgrade3) { create :squad_upgrade, squad: squad1, available_upgrade: available_upgrade1 }
    let!(:squad_upgrade4) { create :squad_upgrade, squad: squad3, available_upgrade: available_upgrade4 }

    subject { instance.remove_available_upgrades(disabled_upgrades) }

    it "removes the AvailableUpgrade for the disabled_upgrade and unit" do
      expect { subject }.to change { AvailableUpgrade.count }.by(-1)
      expect(AvailableUpgrade.exists?(available_upgrade3.id)).to be false
    end

    it "removes SquadUpgrades associated with the removed AvailableUpgrade" do
      expect { subject }.to change { SquadUpgrade.count }.by(-1)
      expect(SquadUpgrade.exists?(squad_upgrade2.id)).to be false
    end

    it "does not affect AvailableUpgrades for the upgrade that have units not associated with the disabled upgrade" do
      subject
      expect(AvailableUpgrade.exists?(available_upgrade4.id)).to be true
      expect(SquadUpgrade.exists?(squad_upgrade4.id)).to be true
    end
  end

  describe "#add_upgrade_modifications" do
    let(:add_man) { 100 }
    let(:add_mun) { -25 }
    let(:add_pop) { 1 }
    let(:replace_mun) { 50 }
    let(:replace_uses) { 5 }
    let!(:unlock1) { create :unlock }
    let!(:unlock2) { create :unlock }
    let!(:doctrine_unlock) { create :doctrine_unlock, doctrine: doctrine, unlock: unlock1, ruleset: ruleset }
    let!(:du_restriction) { create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock }
    let!(:doc_available_upgrade1) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit1,
                                           man: 0, mun: 35, fuel: 0, pop: 0, uses: 2 }
    let!(:doc_available_upgrade2) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit2,
                                           man: 0, mun: 35, fuel: 0, pop: 0, uses: 2 }

    let!(:du_modified_replace_upgrade) { create :modified_replace_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset,
                                                mun: replace_mun, uses: replace_uses, priority: 50 }
    let!(:du_modified_add_upgrade) { create :modified_add_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset,
                                            man: add_man, mun: add_mun, pop: add_pop, priority: 60 }

    before do
      create :restriction_upgrade_unit, restriction_upgrade: du_modified_replace_upgrade, unit: unit1
      create :restriction_upgrade_unit, restriction_upgrade: du_modified_add_upgrade, unit: unit1
      create :restriction_upgrade_unit, restriction_upgrade: du_modified_add_upgrade, unit: unit2
    end

    subject { instance.add_upgrade_modifications([du_modified_replace_upgrade, du_modified_add_upgrade], doctrine_unlock) }

    it "applies both modifications to upgrade1/unit1" do
      subject
      expect(doc_available_upgrade1.reload.man).to eq add_man
      expect(doc_available_upgrade1.mun).to eq replace_mun + add_mun
      expect(doc_available_upgrade1.fuel).to eq 0
      expect(doc_available_upgrade1.pop).to eq add_pop
      expect(doc_available_upgrade1.uses).to eq replace_uses
    end

    it "applies only the add modification to upgrade1/unit2" do
      subject
      expect(doc_available_upgrade2.reload.man).to eq add_man
      expect(doc_available_upgrade2.mun).to eq 35 + add_mun
      expect(doc_available_upgrade2.fuel).to eq 0
      expect(doc_available_upgrade2.pop).to eq add_pop
      expect(doc_available_upgrade2.uses).to eq 2
    end
  end

  describe "#remove_upgrade_modifications" do
    let(:add_man) { 100 }
    let(:add_mun) { -25 }
    let(:add_pop) { 1 }
    let(:replace_mun) { 50 }
    let(:replace_uses) { 5 }
    let!(:unlock1) { create :unlock }
    let!(:unlock2) { create :unlock }
    let!(:doctrine_unlock) { create :doctrine_unlock, doctrine: doctrine, unlock: unlock1, ruleset: ruleset }
    let!(:du_restriction) { create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock }
    let!(:doctrine_unlock2) { create :doctrine_unlock, doctrine: doctrine, unlock: unlock2, tree: 1, branch: 1, row: 2, ruleset: ruleset }
    let!(:du_restriction2) { create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock2 }
    let!(:doc_available_upgrade1) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit1,
                                           man: add_man, mun: replace_mun + add_mun, fuel: 0, pop: add_pop, uses: replace_uses }
    let!(:doc_available_upgrade2) { create :base_available_upgrade, company: company, upgrade: upgrade1, unit: unit2,
                                           man: add_man, mun: 35 + add_mun, fuel: 0, pop: add_pop, uses: 2 }

    let!(:du_modified_replace_upgrade) { create :modified_replace_upgrade, restriction: du_restriction, upgrade: upgrade1, ruleset: ruleset,
                                                mun: replace_mun, uses: replace_uses, priority: 50 }
    let!(:du_modified_add_upgrade) { create :modified_add_upgrade, restriction: du_restriction2, upgrade: upgrade1, ruleset: ruleset,
                                            man: add_man, mun: add_mun, pop: add_pop, priority: 60 }

    before do
      create :restriction_upgrade_unit, restriction_upgrade: du_modified_replace_upgrade, unit: unit1
      create :restriction_upgrade_unit, restriction_upgrade: du_modified_add_upgrade, unit: unit1
      create :restriction_upgrade_unit, restriction_upgrade: du_modified_add_upgrade, unit: unit2
      create :company_unlock, company: company, doctrine_unlock: doctrine_unlock
      create :company_unlock, company: company, doctrine_unlock: doctrine_unlock2
    end

    subject { instance.remove_upgrade_modifications([du_modified_replace_upgrade], doctrine_unlock) }

    it "removes the replace modification from the AvailableUpgrade for upgrade1/unit1" do
      subject
      expect(doc_available_upgrade1.reload.man).to eq add_man
      expect(doc_available_upgrade1.mun).to eq 40 + add_mun # from enabled_upgrade1_doctrine
      expect(doc_available_upgrade1.fuel).to eq 0
      expect(doc_available_upgrade1.pop).to eq add_pop
      expect(doc_available_upgrade1.uses).to eq 3 # from enabled_upgrade1_doctrine
    end

    it "does not change the AvailableUpgrade for upgrade1/unit2" do
      subject
      expect(doc_available_upgrade2.reload.man).to eq add_man
      expect(doc_available_upgrade2.mun).to eq 35 + add_mun
      expect(doc_available_upgrade2.fuel).to eq 0
      expect(doc_available_upgrade2.pop).to eq add_pop
      expect(doc_available_upgrade2.uses).to eq 2
    end
  end

  describe "#create_enabled_available_upgrades" do
    let(:enabled_hash) do
      {
        upgrade1.id => {
          unit1.id => enabled_upgrade1_doctrine,
          unit2.id => enabled_upgrade1
        },
        upgrade2.id => {
          unit2.id => enabled_upgrade2,
          unit3.id => enabled_upgrade2
        },
        upgrade3.id => {
          unit3.id => enabled_upgrade3
        }
      }
    end

    subject { instance.send(:create_enabled_available_upgrades, enabled_hash) }

    it "creates 5 AvailableUpgrades" do
      expect { subject }.to change { AvailableUpgrade.count }.by 5
    end

    it "creates AvailableUpgrades for upgrade1" do
      expect { subject }.to change { AvailableUpgrade.where(upgrade: upgrade1).count }.by 2
      au1 = AvailableUpgrade.find_by(company: company, upgrade: upgrade1, unit: unit1)
      expect(au1.pop).to eq 0
      expect(au1.man).to eq 0
      expect(au1.mun).to eq 40
      expect(au1.fuel).to eq 0
      expect(au1.uses).to eq 3
      au2 = AvailableUpgrade.find_by(company: company, upgrade: upgrade1, unit: unit2)
      expect(au2.pop).to eq 0
      expect(au2.man).to eq 0
      expect(au2.mun).to eq 35
      expect(au2.fuel).to eq 0
      expect(au2.uses).to eq 2
    end

    it "creates AvailableUpgrades for upgrade2" do
      expect { subject }.to change { AvailableUpgrade.where(upgrade: upgrade2).count }.by 2
      au1 = AvailableUpgrade.find_by(company: company, upgrade: upgrade2, unit: unit2)
      expect(au1.pop).to eq 2
      expect(au1.man).to eq 100
      expect(au1.mun).to eq 35
      expect(au1.fuel).to eq 0
      expect(au1.uses).to eq 0
      au2 = AvailableUpgrade.find_by(company: company, upgrade: upgrade2, unit: unit3)
      expect(au2.pop).to eq 2
      expect(au2.man).to eq 100
      expect(au2.mun).to eq 35
      expect(au2.fuel).to eq 0
      expect(au2.uses).to eq 0
    end

    it "creates AvailableUpgrades for upgrade3" do
      expect { subject }.to change { AvailableUpgrade.where(upgrade: upgrade3).count }.by 1
      au1 = AvailableUpgrade.find_by(company: company, upgrade: upgrade3, unit: unit3)
      expect(au1.pop).to eq 0
      expect(au1.man).to eq 0
      expect(au1.mun).to eq 0
      expect(au1.fuel).to eq 50
      expect(au1.uses).to eq 0
    end
  end

  describe "#get_base_faction_doctrine_upgrade_hash" do
    let(:expected_result) do
      {
        upgrade1.id => {
          unit1.id => enabled_upgrade1_doctrine,
          unit2.id => enabled_upgrade1
        },
        upgrade2.id => {
          unit2.id => enabled_upgrade2,
          unit3.id => enabled_upgrade2
        },
        upgrade3.id => {
          unit3.id => enabled_upgrade3
        }
      }
    end

    it "returns the expected result upgrade hash" do
      result = instance.send(:get_base_faction_doctrine_upgrade_hash)
      expect(result).to eq expected_result
    end

    context "when there are disabled upgrades" do
      let(:doctrine) { doctrine2 }
      let(:expected_result) do
        {
          upgrade1.id => {
            unit1.id => enabled_upgrade1,
            unit2.id => enabled_upgrade1
          },
          upgrade2.id => {
            unit3.id => enabled_upgrade2
          }
        }
      end

      it "returns the expected result upgrade hash" do
        result = instance.send(:get_base_faction_doctrine_upgrade_hash)
        expect(result).to eq expected_result
      end
    end
  end

  describe "#get_enabled_upgrade_hash" do
    let(:expected_result) do
      {
        upgrade1.id => {
          unit1.id => enabled_upgrade1,
          unit2.id => enabled_upgrade1
        },
        upgrade2.id => {
          unit2.id => enabled_upgrade2,
          unit3.id => enabled_upgrade2
        }
      }
    end

    it "returns the expected enabled upgrade hash" do
      result = instance.send(:get_enabled_upgrade_hash, restriction_faction)
      expect(result).to eq expected_result
    end
  end

  describe "#get_disabled_upgrade_hash" do
    let(:expected_result) do
      {
        upgrade2.id => Set[unit2.id]
      }
    end
    it "returns the disabled upgrade hash" do
      result = instance.send(:get_disabled_upgrade_hash, restriction_doctrine2)
      expect(result).to eq expected_result
    end
  end

  describe "#merge_allowed_upgrades" do
    let(:existing_hash) do
      {
        upgrade1.id => {
          unit1.id => enabled_upgrade1,
          unit2.id => enabled_upgrade1
        },
        upgrade2.id => {
          unit2.id => enabled_upgrade2,
          unit3.id => enabled_upgrade2
        }
      }
    end
    let(:doctrine_hash) do
      {
        upgrade1.id => {
          unit1.id => enabled_upgrade1_doctrine
        },
        upgrade3.id => {
          unit3.id => enabled_upgrade3
        }
      }
    end
    let(:expected_result) do
      {
        upgrade1.id => {
          unit1.id => enabled_upgrade1_doctrine,
          unit2.id => enabled_upgrade1
        },
        upgrade2.id => {
          unit2.id => enabled_upgrade2,
          unit3.id => enabled_upgrade2
        },
        upgrade3.id => {
          unit3.id => enabled_upgrade3
        }
      }
    end
    it "returns the merged result" do
      result = instance.send(:merge_allowed_upgrades, existing_hash, doctrine_hash)
      expect(result).to eq expected_result
    end
  end

  describe "#remove_disabled_upgrades" do
    let(:existing_hash) do
      {
        upgrade1.id => {
          unit1.id => enabled_upgrade1_doctrine,
          unit2.id => enabled_upgrade1
        },
        upgrade2.id => {
          unit2.id => enabled_upgrade2,
          unit3.id => enabled_upgrade2
        }
      }
    end
    let(:disabled_hash) do
      {
        upgrade1.id => Set[unit1.id],
        upgrade2.id => Set[unit2.id, unit3.id]
      }
    end
    let(:expected_result) do
      {
        upgrade1.id => {
          unit2.id => enabled_upgrade1
        }
      }
    end

    it "returns the existing hash minus disabled hash" do
      result = instance.send(:remove_disabled_upgrades, existing_hash, disabled_hash)
      expect(result).to eq expected_result
    end
  end

  describe "#instantiate_base_available_upgrade" do
    it "creates a new BaseAvailableUpgrade object" do
      result = instance.send(:instantiate_base_available_upgrade, enabled_upgrade1, unit1.id)
      expect(result.upgrade).to eq enabled_upgrade1.upgrade
      expect(result.unit_id).to eq unit1.id
      expect(result.company).to eq company
      expect(result.pop).to eq enabled_upgrade1.pop
      expect(result.man).to eq enabled_upgrade1.man
      expect(result.mun).to eq enabled_upgrade1.mun
      expect(result.fuel).to eq enabled_upgrade1.fuel
      expect(result.uses).to eq enabled_upgrade1.uses
    end
  end
end
