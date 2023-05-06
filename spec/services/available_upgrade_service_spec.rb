require "rails_helper"

RSpec.describe AvailableUpgradeService do
  let!(:player) { create :player }
  let!(:ruleset) { create :ruleset }
  let(:faction) { create :faction }
  let(:faction2) { create :faction }
  let(:doctrine1) { create :doctrine, faction: faction }
  let(:doctrine2) { create :doctrine, faction: faction }
  let(:doctrine) { doctrine1 }
  let!(:company) { create :company, faction: faction, doctrine: doctrine, ruleset: ruleset }
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

    subject { instance.create_enabled_available_upgrades(enabled_hash) }

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
