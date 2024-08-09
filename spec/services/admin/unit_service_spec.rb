require "rails_helper"

RSpec.describe Admin::UnitService do
  let(:base_man) { 200 }
  let(:base_mun) { 100 }
  let(:base_fuel) { 50 }
  let(:ruleset) { create :ruleset, starting_man: base_man, starting_mun: base_mun, starting_fuel: base_fuel }
  let(:unit1) { create :unit }
  let(:unit2) { create :unit }

  describe "#disable" do
    let(:man_cost) { 45 }
    let(:mun_cost) { 8 }
    let(:fuel_cost) { 12 }

    let(:man_cost2) { 20 }
    let(:mun_cost2) { 5 }
    let(:fuel_cost2) { 1 }

    let(:company_with_two_squads) { create :active_company, ruleset: ruleset, man: base_man - man_cost * 2 - man_cost2, mun: base_mun - mun_cost * 2 - mun_cost2, fuel: base_fuel - fuel_cost * 2 - fuel_cost2 }
    let(:company_with_one_squad) { create :active_company, ruleset: ruleset, man: base_man - man_cost - man_cost2, mun: base_mun - mun_cost - mun_cost2, fuel: base_fuel - fuel_cost - fuel_cost2 }
    let(:unaffected_company) { create :active_company, ruleset: ruleset, man: base_man - man_cost2, mun: base_mun - mun_cost2, fuel: base_fuel - fuel_cost2 }

    let(:snapshot) { create :snapshot_company, ruleset: ruleset, man: base_man, mun: base_mun, fuel: base_fuel }

    let(:au11) { create :available_unit, company: company_with_two_squads, unit: unit1, man: man_cost, mun: mun_cost, fuel: fuel_cost }
    let!(:squad_co1_11) { create :squad, company: company_with_two_squads, available_unit: au11 }
    let!(:squad_co1_12) { create :squad, company: company_with_two_squads, available_unit: au11 }
    let!(:squad_co2_11) do
      au21 = create :available_unit, company: company_with_one_squad, unit: unit1, man: man_cost, mun: mun_cost, fuel: fuel_cost
      create :squad, company: company_with_one_squad, available_unit: au21
    end

    let!(:squad_co1_21) do
      au12 = create :available_unit, company: company_with_two_squads, unit: unit2, man: man_cost2, mun: mun_cost2, fuel: fuel_cost2
      create :squad, company: company_with_two_squads, available_unit: au12
    end

    let(:subject) { described_class.new(ruleset).disable(unit1) }

    before do
      create :available_unit, company: unaffected_company, unit: unit1, man: man_cost, mun: mun_cost, fuel: fuel_cost
      au22 = create :available_unit, company: company_with_one_squad, unit: unit2, man: man_cost2, mun: mun_cost2, fuel: fuel_cost2
      au32 = create :available_unit, company: unaffected_company, unit: unit2, man: man_cost2, mun: mun_cost2, fuel: fuel_cost2

      aus = create :available_unit, company: snapshot, unit: unit1

      create :squad, company: company_with_one_squad, available_unit: au22
      create :squad, company: unaffected_company, available_unit: au32

      create :squad, company: snapshot, available_unit: aus
    end

    it "destroys all squads associated with that unit for ActiveCompanies" do
      expect { subject }.to change { Squad.count }.by(-3)
    end

    it "does not affect SnapshotCompanies" do
      subject
      expect(snapshot.reload.squads.count).to eq 1
      expect(snapshot.squads.first.unit.id).to eq unit1.id
      expect(snapshot.man).to eq base_man
      expect(snapshot.mun).to eq base_mun
      expect(snapshot.fuel).to eq base_fuel
    end

    it "updated affected company resources" do
      subject
      expect(company_with_two_squads.reload.man).to eq base_man - man_cost2
      expect(company_with_one_squad.reload.man).to eq base_man - man_cost2

      expect(company_with_two_squads.mun).to eq base_mun - mun_cost2
      expect(company_with_one_squad.mun).to eq base_mun - mun_cost2

      expect(company_with_two_squads.fuel).to eq base_fuel - fuel_cost2
      expect(company_with_one_squad.fuel).to eq base_fuel - fuel_cost2
    end

    context "when there are squad upgrades" do
      let(:upgrade) { create :upgrade }
      let(:upgrade_man) { 10 }
      let(:upgrade_mun) { 3 }
      let(:upgrade_fuel) { 2 }
      let(:company_with_two_squads) do
        create :active_company, ruleset: ruleset,
               man: base_man - man_cost * 2 - man_cost2 - upgrade_man,
               mun: base_mun - mun_cost * 2 - mun_cost2 - upgrade_mun,
               fuel: base_fuel - fuel_cost * 2 - fuel_cost2 - upgrade_fuel
      end

      before do
        available_upgrade = create :available_upgrade, company: company_with_two_squads, upgrade: upgrade, man: upgrade_man, mun: upgrade_mun, fuel: upgrade_fuel
        create :squad_upgrade, squad: squad_co1_11, available_upgrade: available_upgrade
      end

      it "destroys the squad upgrade" do
        expect { subject }.to change { SquadUpgrade.count }.by(-1)
      end

      it "updates affected company resources" do
        subject
        expect(company_with_two_squads.reload.man).to eq base_man - man_cost2
        expect(company_with_two_squads.mun).to eq base_mun - mun_cost2
        expect(company_with_two_squads.fuel).to eq base_fuel - fuel_cost2
      end
    end

    context "when there are transport associations" do
      let!(:transported_squad) { create :transported_squad, transport_squad: squad_co1_21, embarked_squad: squad_co1_11 }

      it "destroys the transported squad" do
        expect { subject }.to change { TransportedSquad.count }.by(-1)
      end
    end
  end
end
