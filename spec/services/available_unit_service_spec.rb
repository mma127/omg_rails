require "rails_helper"

RSpec.describe AvailableUnitService do
  let!(:player) { create :player }
  let!(:ruleset) { create :ruleset }
  let(:faction) { create :faction }
  let(:faction2) { create :faction }
  let(:doctrine) { create :doctrine, faction: faction }
  let!(:company) { create :company, faction: faction, doctrine: doctrine, ruleset: ruleset }
  let!(:restriction_faction) { create :restriction, faction: faction, doctrine: nil, unlock: nil, description: "for faction #{faction.id}" }
  let!(:restriction_faction2) { create :restriction, faction: faction2, doctrine: nil, unlock: nil, description: "for faction #{faction2.id}" }
  let!(:restriction_doctrine) { create :restriction, faction: nil, doctrine: doctrine, unlock: nil, name: "doctrine level", description: "for doctrine #{doctrine.id}" }
  let(:unit1) { create :unit }
  let(:unit2) { create :unit }
  let(:unit3) { create :unit }
  let(:unit4) { create :unit }
  let(:unit5) { create :unit }
  let(:unit6) { create :unit }
  let!(:restriction_unit1) { create :enabled_unit, unit: unit1, man: 200, pop: 4, resupply: 4, resupply_max: 6, company_max: 10, restriction: restriction_faction, ruleset: ruleset }
  let!(:restriction_unit1_doctrine) { create :enabled_unit, unit: unit1, man: 300, pop: 5, resupply: 2, resupply_max: 4, company_max: 8, restriction: restriction_doctrine, ruleset: ruleset }
  let!(:restriction_unit2) { create :enabled_unit, unit: unit2, pop: 7, resupply: 2, resupply_max: 5, company_max: 5, restriction: restriction_faction, ruleset: ruleset }
  let!(:restriction_unit3) { create :enabled_unit, unit: unit3, pop: 13, fuel: 700, resupply: 1, resupply_max: 1, company_max: 2, restriction: restriction_doctrine, ruleset: ruleset }
  let!(:restriction_unit4) { create :enabled_unit, unit: unit4, pop: 16, mun: 225, resupply: 1, resupply_max: 1, company_max: 1, restriction: restriction_faction, ruleset: ruleset }
  let!(:restriction_unit5) { create :enabled_unit, unit: unit5, pop: 5, resupply: 10, resupply_max: 15, company_max: 15, restriction: restriction_doctrine, ruleset: ruleset }
  let!(:restriction_unit6) { create :enabled_unit, unit: unit6, pop: 5, resupply: 99, resupply_max: 99, company_max: 100, restriction: restriction_faction2, ruleset: ruleset }
  let!(:disabled_restriction_unit_2) { create :disabled_unit, unit: unit2, restriction: restriction_doctrine, ruleset: ruleset }
  let(:man1) { 250 }
  let(:mun1) { 120 }
  let(:fuel1) { 80 }
  let(:pop1) { 6 }
  let(:resupply_max) { 10 }

  subject { described_class.new(company) }

  context "#build_new_company_available_units" do
    it "creates the correct number of AvailableUnits" do
      subject.build_new_company_available_units

      available_units = company.reload.available_units
      expect(available_units.size).to eq 4
      expect(available_units.pluck(:unit_id)).to match_array [unit1.id, unit3.id, unit4.id, unit5.id]
    end

    it "creates the AvailableUnit for unit1" do
      subject.build_new_company_available_units
      au = AvailableUnit.find_by(company: company, unit: unit1)
      expect(au.pop).to eq 5
      expect(au.man).to eq 300
      expect(au.resupply).to eq 2
      expect(au.company_max).to eq 8
    end

    it "creates the AvailableUnit for unit3" do
      subject.build_new_company_available_units
      au = AvailableUnit.find_by(company: company, unit: unit3)
      expect(au.pop).to eq 13
      expect(au.fuel).to eq 700
      expect(au.resupply).to eq 1
      expect(au.company_max).to eq 2
    end

    it "creates the AvailableUnit for unit4" do
      subject.build_new_company_available_units
      au = AvailableUnit.find_by(company: company, unit: unit4)
      expect(au.pop).to eq 16
      expect(au.mun).to eq 225
      expect(au.resupply).to eq 1
      expect(au.company_max).to eq 1
    end

    it "creates the AvailableUnit for unit5" do
      subject.build_new_company_available_units
      au = AvailableUnit.find_by(company: company, unit: unit5)
      expect(au.pop).to eq 5
      expect(au.resupply).to eq 10
      expect(au.company_max).to eq 15
    end

    context "when the company has existing AvailableUnits" do
      before do
        create :available_unit, company: company, unit: unit1
      end

      it "raises an error" do
        expect { subject.build_new_company_available_units }.to raise_error "Company #{company.id} has existing AvailableUnits"
      end
    end
  end

  context "#get_enabled_unit_hash" do
    it "returns all EnabledUnits by unit id for the faction restriction" do
      result = subject.send(:get_enabled_unit_hash, restriction_faction)
      expect(result.size).to eq 3
      expect(result.keys).to match_array [unit1.id, unit2.id, unit4.id]
      expect(result.values).to match_array [restriction_unit1, restriction_unit2, restriction_unit4]
    end

    it "returns all EnabledUnits by unit id for the doctrine restriction" do
      result = subject.send(:get_enabled_unit_hash, restriction_doctrine)
      expect(result.size).to eq 3
      expect(result.keys).to match_array [unit1.id, unit3.id, unit5.id]
      expect(result.values).to match_array [restriction_unit1_doctrine, restriction_unit3, restriction_unit5]
    end
  end

  context "#get_disabled_unit_hash" do
    it "returns all DisabledUnits by unit id for the doctrine restriction" do
      result = subject.send(:get_disabled_unit_hash, restriction_doctrine)
      expect(result.size).to eq 1
      expect(result.keys).to match_array [unit2.id]
      expect(result.values).to match_array [disabled_restriction_unit_2]
    end
  end

  context "#merge_allowed_units" do
    let(:existing_units_hash) { { unit1.id => restriction_unit1, unit2.id => restriction_unit2 } }

    it "adds an entry if the existing_units_hash doesn't have that key" do
      restricted_units_hash = { unit3.id => restriction_unit3 }
      result = subject.send(:merge_allowed_units, existing_units_hash, restricted_units_hash)
      expect(result.size).to eq 3
      expect(result.keys).to match_array [unit1.id, unit2.id, unit3.id]
      expect(result[unit3.id]).to eq restriction_unit3
    end

    it "replaces an existing entry if the restricted_units_hash also contains that key" do
      restricted_units_hash = { unit1.id => restriction_unit1_doctrine }
      result = subject.send(:merge_allowed_units, existing_units_hash, restricted_units_hash)
      expect(result.size).to eq 2
      expect(result.keys).to match_array [unit1.id, unit2.id]
      expect(result[unit1.id]).to eq restriction_unit1_doctrine
    end
  end

  context "#remove_disabled_units" do
    let(:existing_units_hash) { { unit1.id => restriction_unit1, unit2.id => restriction_unit2 } }

    it "removes all units that are disabled from the existing units hash" do
      disabled_units_hash = { unit2.id => disabled_restriction_unit_2 }
      result = subject.send(:remove_disabled_units, existing_units_hash, disabled_units_hash)
      expect(result.size).to eq 1
      expect(result.keys).to match_array [unit1.id]
    end

    it "removes nothing when the disabled units hash is empty" do
      disabled_units_hash = {}
      result = subject.send(:remove_disabled_units, existing_units_hash, disabled_units_hash)
      expect(result.size).to eq 2
      expect(result.keys).to match_array [unit1.id, unit2.id]
    end
  end

  context "#create_enabled_available_units" do
    context "when the company is valid" do
      before do
        unit_hash = { unit1.id => restriction_unit1_doctrine, unit2.id => restriction_unit2 }
        subject.send(:create_enabled_available_units, unit_hash.values)
      end

      it "creates AvailableUnits from the given restriction units" do
        available_units = AvailableUnit.where(company: company)
        expect(available_units.size).to eq 2
        expect(available_units.pluck(:unit_id)).to match_array [unit1.id, unit2.id]
      end

      it "creates an AvailableUnit for unit1 with the correct attributes" do
        au = AvailableUnit.find_by(company: company, unit: unit1)
        expect(au.man).to eq 300
        expect(au.pop).to eq 5
        expect(au.resupply).to eq 2
        expect(au.resupply_max).to eq 4
        expect(au.company_max).to eq 8
      end

      it "creates an AvailableUnit for unit2 with the correct attributes" do
        au = AvailableUnit.find_by(company: company, unit: unit2)
        expect(au.pop).to eq 7
        expect(au.resupply).to eq 2
        expect(au.resupply_max).to eq 5
        expect(au.company_max).to eq 5
      end
    end

    context "when the company has existing AvailableUnits" do
      before do
        create :available_unit, company: company, unit: unit1
      end
      it "doesn't raise an error, because it doesn't matter to this method" do
        expect { subject.send(:create_enabled_available_units, []) }.not_to raise_error
      end
    end
  end

  describe "#recreate_disabled_from_doctrine_unlock" do
    let(:units_disabled) { [unit1, unit2, unit3] } # These were previously disabled but unit2 has a disable_unit on the doctrine
    let!(:doctrine_unlock) { create :doctrine_unlock }
    let(:du_restriction) { doctrine_unlock.restriction }

    before do
      create :company_unlock, company: company, doctrine_unlock: doctrine_unlock
    end

    context "when the available_units should come from the faction/doctrine base set" do
      it "creates BaseAvailableUnits for the given units that are enabled by the faction & doctrine" do
        expect { subject.recreate_disabled_from_doctrine_unlock(units_disabled, doctrine_unlock) }.to change { BaseAvailableUnit.count }.by(2)
        expect(BaseAvailableUnit.find_by(company: company, unit: unit1).present?).to be true
        expect(BaseAvailableUnit.find_by(company: company, unit: unit2).present?).to be false
        expect(BaseAvailableUnit.find_by(company: company, unit: unit3).present?).to be true
        expect(BaseAvailableUnit.count).to eq 2

        expect(BaseAvailableUnit.all.pluck(:unit_id)).to match_array [unit1.id, unit3.id]
      end
    end

    context "when the available_units are also affected by a doctrine_unlock enabling one" do
      before do
        # Create doctrine unlock that enables unit2
        doctrine_unlock2 = create :doctrine_unlock
        restriction_du2 = create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock2
        create :enabled_unit, unit: unit2, restriction: restriction_du2, ruleset: ruleset
        company_unlock2 = create :company_unlock, company: company, doctrine_unlock: doctrine_unlock2
      end
      # should see that 3 available units are created
      it "creates BaseAvailableUnits for the given units that are enabled by the faction & doctrine & doctrine unlock" do
        expect { subject.recreate_disabled_from_doctrine_unlock(units_disabled, doctrine_unlock) }.to change { BaseAvailableUnit.count }.by(3)
        expect(BaseAvailableUnit.find_by(company: company, unit: unit1).present?).to be true
        expect(BaseAvailableUnit.find_by(company: company, unit: unit2).present?).to be true
        expect(BaseAvailableUnit.find_by(company: company, unit: unit3).present?).to be true
        expect(BaseAvailableUnit.count).to eq 3

        expect(BaseAvailableUnit.all.pluck(:unit_id)).to match_array [unit1.id, unit2.id, unit3.id]
      end
    end

    context "when the available_units are also affected by a doctrine_unlock enabling one and a doctrine_unlock disabling one" do
      before do
        # Create doctrine unlock that enables unit2
        doctrine_unlock2 = create :doctrine_unlock
        doctrine_unlock3 = create :doctrine_unlock
        restriction_du2 = create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock2
        restriction_du3 = create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock3
        create :enabled_unit, unit: unit2, restriction: restriction_du2, ruleset: ruleset
        create :disabled_unit, unit: unit3, restriction: restriction_du3, ruleset: ruleset
        create :company_unlock, company: company, doctrine_unlock: doctrine_unlock2
        create :company_unlock, company: company, doctrine_unlock: doctrine_unlock3
      end
      # should see that 2 available units are created
      it "creates BaseAvailableUnits for the given units that are enabled/disabled by the faction & doctrine & doctrine unlock" do
        expect { subject.recreate_disabled_from_doctrine_unlock(units_disabled, doctrine_unlock) }.to change { BaseAvailableUnit.count }.by(2)
        expect(BaseAvailableUnit.find_by(company: company, unit: unit1).present?).to be true
        expect(BaseAvailableUnit.find_by(company: company, unit: unit2).present?).to be true
        expect(BaseAvailableUnit.find_by(company: company, unit: unit3).present?).to be false
        expect(BaseAvailableUnit.count).to eq 2

        expect(BaseAvailableUnit.all.pluck(:unit_id)).to match_array [unit1.id, unit2.id]
      end
    end
  end

  describe "#remove_available_units" do
    let!(:available_unit1) { create :base_available_unit, unit: unit1, company: company }
    let!(:available_unit2) { create :base_available_unit, unit: unit2, company: company }
    let!(:squad1) { create :squad, company: company, available_unit: available_unit1 }
    let!(:squad2) { create :squad, company: company, available_unit: available_unit1 }
    let!(:squad3) { create :squad, company: company, available_unit: available_unit2 }
    let(:units_to_remove) { [unit1] }

    it "removes available_units matching the given units" do
      expect { subject.send(:remove_available_units, units_to_remove) }.to change { AvailableUnit.count }.by(-1)
      expect(AvailableUnit.exists?(available_unit1.id)).to be false
      expect(available_unit2.destroyed?).to be false
    end

    it "removes squads associated with the removed available_units" do
      expect { subject.send(:remove_available_units, units_to_remove) }.to change { Squad.count }.by(-2)
      expect(Squad.exists?(squad1.id)).to be false
      expect(Squad.exists?(squad2.id)).to be false
      expect(squad3.destroyed?).to be false
    end
  end

  describe "#add_unit_modifications" do
    let(:add_man) { 100 }
    let(:add_fuel) { 25 }
    let(:add_pop) { -1 }
    let(:replace_fuel) { 0 }
    let(:replace_resupply) { 5 }
    let!(:unlock1) { create :unlock }
    let!(:unlock2) { create :unlock }
    let!(:doctrine_unlock) { create :doctrine_unlock, doctrine: doctrine, unlock: unlock1 }
    let!(:du_restriction) { create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock }
    let!(:doc_restriction) { create :restriction, :with_doctrine, doctrine: doctrine }
    let!(:doc_enabled_unit) { create :enabled_unit, restriction: doc_restriction, unit: unit1, ruleset: ruleset,
                                     man: man1, mun: mun1, fuel: fuel1, pop: pop1, resupply: resupply_max, resupply_max: resupply_max }
    let!(:au) { create :base_available_unit, company: company, unit: unit1, man: man1, mun: mun1, fuel: fuel1, pop: pop1,
                       resupply: resupply_max, resupply_max: resupply_max}

    let!(:du_modified_replace_unit) { create :modified_replace_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                             fuel: replace_fuel, resupply: replace_resupply, priority: 50 }
    let!(:du_modified_add_unit) { create :modified_add_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                         man: add_man, fuel: add_fuel, pop: add_pop, priority: 60 }

    it "applies all modifications for the doctrine unlock" do
      subject.add_unit_modifications([du_modified_add_unit, du_modified_replace_unit], doctrine_unlock)

      expect(au.reload.man).to eq man1 + add_man
      expect(au.mun).to eq mun1
      expect(au.fuel).to eq replace_fuel + add_fuel
      expect(au.pop).to eq pop1 + add_pop
      expect(au.resupply).to eq replace_resupply
      expect(au.resupply_max).to eq resupply_max
    end
  end

  describe "#remove_unit_modifications" do
    let(:add_man) { 100 }
    let(:add_fuel) { 25 }
    let(:add_pop) { -1 }
    let(:replace_fuel) { 0 }
    let(:replace_resupply) { 5 }
    let!(:unlock1) { create :unlock }
    let!(:unlock2) { create :unlock }
    let!(:doctrine_unlock) { create :doctrine_unlock, doctrine: doctrine, unlock: unlock1 }
    let!(:du_restriction) { create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock }
    let!(:doctrine_unlock2) { create :doctrine_unlock, doctrine: doctrine, unlock: unlock2, tree: 1, branch: 1, row: 2 }
    let!(:du_restriction2) { create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock2 }
    let!(:doc_restriction) { create :restriction, :with_doctrine, doctrine: doctrine }
    let!(:doc_enabled_unit) { create :enabled_unit, restriction: doc_restriction, unit: unit1, ruleset: ruleset,
                                     man: man1, mun: mun1, fuel: fuel1, pop: pop1, resupply: resupply_max, resupply_max: resupply_max }
    let!(:au) { create :base_available_unit, company: company, unit: unit1, man: man1 + add_man, mun: mun1, fuel: replace_fuel + add_fuel, pop: pop1 + add_pop,
                       resupply: replace_resupply, resupply_max: resupply_max}

    let!(:du_modified_replace_unit) { create :modified_replace_unit, restriction: du_restriction, unit: unit1, ruleset: ruleset,
                                             fuel: replace_fuel, resupply: replace_resupply, priority: 50 }
    let!(:du_modified_add_unit) { create :modified_add_unit, restriction: du_restriction2, unit: unit1, ruleset: ruleset,
                                         man: add_man, fuel: add_fuel, pop: add_pop, priority: 60 }
    before do
      create :company_unlock, company: company, doctrine_unlock: doctrine_unlock
      create :company_unlock, company: company, doctrine_unlock: doctrine_unlock2
    end

    it "removes the modification but reapplies all other modifications not being removed" do
      subject.remove_unit_modifications([du_modified_replace_unit], doctrine_unlock)
      expect(au.reload.man).to eq man1 + add_man
      expect(au.mun).to eq mun1
      expect(au.fuel).to eq fuel1 + add_fuel
      expect(au.pop).to eq pop1 + add_pop
      expect(au.resupply).to eq resupply_max
      expect(au.resupply_max).to eq resupply_max
    end
  end

  context "#validate_empty_available_units" do
    context "when the company has existing AvailableUnits" do
      before do
        create :available_unit, company: company, unit: unit1
      end
      it "raises an error" do
        expect { subject.send(:validate_empty_available_units) }.to raise_error "Company #{company.id} has existing AvailableUnits"
      end
    end
    context "when the company has no AvailableUnits" do
      it "passes" do
        expect { subject.send(:validate_empty_available_units) }.not_to raise_error
      end
    end
  end
end
