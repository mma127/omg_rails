require "rails_helper"

RSpec.describe BattleReportService do
  let!(:player1) { create :player }
  let!(:player2) { create :player }
  let(:ruleset) { create :ruleset }
  let!(:battle) { create :battle, ruleset: ruleset, state: "ingame" }
  let(:unit1) { create :unit }
  let(:unit2) { create :unit }

  let!(:company1) { create :company, player: player1, ruleset: ruleset }
  let!(:company2) { create :company, player: player2, ruleset: ruleset }
  let!(:available_unit1) { create :available_unit, unit: unit1, company: company1, available: 10, resupply: 5, resupply_max: 10 }
  let!(:available_unit2) { create :available_unit, unit: unit2, company: company2, available: 80, resupply: 10, resupply_max: 99 }
  let!(:squad11) { create :squad, available_unit: available_unit1, company: company1 }
  let!(:squad12) { create :squad, available_unit: available_unit1, company: company1, vet: 20 }
  let!(:squad21) { create :squad, available_unit: available_unit2, company: company2 }
  let!(:squad22) { create :squad, available_unit: available_unit2, company: company2, vet: 45 }
  let!(:squad23) { create :squad, available_unit: available_unit2, company: company2, tab_category: "infantry", category_position: 2 }
  let!(:squad23) { create :squad, available_unit: available_unit2, company: company2, tab_category: "infantry", category_position: 2 }

  subject(:instance) { described_class.new(battle.id) }

  before do
    create :battle_player, battle: battle, player: player1, company: company1
    create :battle_player, battle: battle, player: player2, company: company2
  end

  describe "#process_report" do
    let(:race_winner) { "Allies" }
    let(:dead_squads_str) { "#{squad12.id};#{squad22.id}" }
    let(:surviving_squads) { "#{squad11.id},1.0;#{squad21.id},5.0" }

    subject(:process_report) { instance.process_report(battle.id, true, player1.name, 600,
                                                       race_winner, "",
                                                       dead_squads_str, surviving_squads, "", {}) }

    context "when the game is valid for processing" do
      it "updates surviving squads' vet" do
        expect(squad11.vet).to eq 0
        expect(squad21.vet).to eq 0
        process_report
        expect(squad11.reload.vet).to eq 1
        expect(squad21.reload.vet).to eq 5
      end

      it "autorebuilds the dead squads" do
        expect(squad12.vet).to eq 20
        expect(squad22.vet).to eq 45

        process_report

        expect(squad12.reload.vet).to eq 0
        expect(squad22.reload.vet).to eq 0
      end

      it "adds rubberband vet to non-called in squads" do
        expect(squad23.vet).to eq 0
        process_report
        expect(squad23.reload.vet).to eq described_class::RUBBERBAND_VET
      end

      it "updates availability" do
        process_report
        expect(available_unit1.reload.available).to eq 10
        expect(available_unit2.reload.available).to eq 90
      end

      it "updates company resources" do
        process_report
        expect(company1.reload.man).to eq ruleset.starting_man - available_unit1.man * 2
        expect(company1.mun).to eq ruleset.starting_mun - available_unit1.mun * 2
        expect(company1.fuel).to eq ruleset.starting_fuel - available_unit1.fuel * 2

        expect(company2.reload.man).to eq ruleset.starting_man - available_unit2.man * 3
        expect(company2.mun).to eq ruleset.starting_mun - available_unit2.mun * 3
        expect(company2.fuel).to eq ruleset.starting_fuel - available_unit2.fuel * 3
      end

      it "updates company VPs" do
        process_report
        expect(company1.reload.vps_earned).to eq 1
        expect(company2.reload.vps_earned).to eq 1
      end

      it "updates player VPs" do
        process_report
        expect(player1.reload.vps).to eq 1
        expect(player2.reload.vps).to eq 1
      end

      it "finalizes the battle" do
        process_report
        expect(battle.reload.winner).to eq race_winner
        expect(battle.final?).to be true
      end
    end

    context "when an error is raised during processing" do
      before do
        expect(instance).to receive(:finalize_battle).and_raise StandardError, "Unexpected error"
      end

      it "does not change the battle's state" do
        expect { process_report }.to raise_error StandardError, "Unexpected error"
        expect(battle.reload.ingame?).to be true
        expect(battle.winner).to eq nil
      end

      it "does not change company values" do
        expect { process_report }.to raise_error StandardError, "Unexpected error"
        expect(company1.reload.vps_earned).to eq 0
        expect(company2.reload.vps_earned).to eq 0
        expect(company1.man).to eq 7000
        expect(company1.mun).to eq 1600
        expect(company1.fuel).to eq 1400
        expect(company2.man).to eq 7000
        expect(company2.mun).to eq 1600
        expect(company2.fuel).to eq 1400
      end

      it "does not change squads" do
        expect { process_report }.to raise_error(StandardError, "Unexpected error")
        expect(squad11.reload.vet).to eq 0
        expect(squad21.reload.vet).to eq 0
        expect(squad12.reload.vet).to eq 20
        expect(squad22.reload.vet).to eq 45
        expect(squad23.reload.vet).to eq 0
      end
    end
  end

  describe "#validate_battle_ingame" do
    context "when the battle state is 'ingame'" do
      before do
        battle.update!(state: "ingame")
      end

      it "does not raise an error" do
        expect { instance.send(:validate_battle_ingame) }.not_to raise_error
      end
    end

    context "when the battle state is not 'ingame'" do
      before do
        battle.update!(state: "reporting")
      end

      it "raises an error" do
        expect { instance.send(:validate_battle_ingame) }.to raise_error BattleReportService::BattleReportValidationError,
                                                                         "Invalid battle state 'reporting', expected 'ingame'"
      end
    end
  end

  describe "#update_surviving_squads" do
    let(:starting_squads_by_id) do
      {
        squad11.id => squad11,
        squad12.id => squad12,
        squad21.id => squad21,
        squad22.id => squad22,
        squad23.id => squad23
      }
    end
    let(:surviving_squads) { "#{squad11.id},1.0;#{squad21.id},5.0;#{squad23.id},24.52" }

    it "removes the surviving squads from starting_squads_by_id" do
      instance.send(:update_surviving_squads, starting_squads_by_id, surviving_squads)
      expect(starting_squads_by_id.size).to eq 2
      expect(starting_squads_by_id.keys).to match_array([squad12.id, squad22.id])
    end

    it "updates the surviving squads' vet" do
      instance.send(:update_surviving_squads, starting_squads_by_id, surviving_squads)
      expect(squad11.reload.vet).to eq 1
      expect(squad21.reload.vet).to eq 5
      expect(squad23.reload.vet).to eq 24.52
    end
  end

  describe "#add_rubberband_vet" do
    let(:starting_squads_by_id) do
      {
        squad11.id => squad11,
        squad12.id => squad12,
      }
    end
    let(:starting_vet_12) { 43.274 }

    before do
      squad11.update!(vet: 0)
      squad12.update!(vet: starting_vet_12)
    end

    it "adds 5 vet exp to every squad given" do
      instance.send(:add_rubberband_vet, starting_squads_by_id)
      expect(squad11.reload.vet).to eq described_class::RUBBERBAND_VET
      expect(squad12.reload.vet).to eq starting_vet_12 + described_class::RUBBERBAND_VET
    end
  end

  describe "#add_company_availability" do
    it "adds resupply to available_units available values" do
      instance.send(:add_company_availability, company2)
      expect(available_unit2.reload.available).to eq 90
    end

    it "does not add resupply over the resupply_max" do
      instance.send(:add_company_availability, company1)
      expect(available_unit1.reload.available).to eq 10
    end
  end

  describe "#autorebuild_dead_squads" do
    let(:dead_squads_str) { "#{squad11.id};#{squad22.id};#{squad23.id}" }
    before do
      squad11.update!(vet: 100, name: "custom_name")
      squad22.update!(vet: 55)
      squad23.update!(vet: 24)
    end

    subject { instance.send(:autorebuild_dead_squads, dead_squads_str) }

    context "when there is sufficient availability" do
      it "rebuilds the dead squads" do
        expect { subject }.not_to change { Squad.count }
        expect(squad11.reload.vet).to eq 0
        expect(squad11.name).to eq nil
        expect(squad22.reload.vet).to eq 0
        expect(squad23.reload.vet).to eq 0
      end

      it "updates the available_unit" do
        subject
        expect(available_unit1.reload.available).to eq 9
        expect(available_unit2.reload.available).to eq 78
      end
    end

    context "when an available_unit has insufficient availability" do
      before do
        available_unit1.update!(available: 0)
        available_unit2.update!(available: 1)
      end

      it "destroys the unavailable squads" do
        expect { subject }.to change { Squad.count }.by(-2)
        expect { squad11.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(squad22.reload.vet).to eq 0
        expect { squad23.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "updates the available_unit" do
        subject
        expect(available_unit1.reload.available).to eq 0
        expect(available_unit2.reload.available).to eq 0
      end
    end
  end

  describe "#recalculate_company_resources" do
    it "updates the company resources" do
      instance.send(:recalculate_company_resources)
      expect(company1.reload.man).to eq ruleset.starting_man - available_unit1.man * 2
      expect(company1.mun).to eq ruleset.starting_mun - available_unit1.mun * 2
      expect(company1.fuel).to eq ruleset.starting_fuel - available_unit1.fuel * 2

      expect(company2.reload.man).to eq ruleset.starting_man - available_unit2.man * 3
      expect(company2.mun).to eq ruleset.starting_mun - available_unit2.mun * 3
      expect(company2.fuel).to eq ruleset.starting_fuel - available_unit2.fuel * 3
    end
  end

  describe "#add_company_vps" do
    let!(:company3) { create :company, player: player1, ruleset: ruleset }
    let!(:company4) { create :company, player: player2, ruleset: ruleset }

    context "when all companies have less than Company::MAX_VP VPs" do
      it "updates all company vps_earned" do
        instance.send(:add_company_vps)
        expect(company1.reload.vps_earned).to eq 1
        expect(company2.reload.vps_earned).to eq 1
        expect(company3.reload.vps_earned).to eq 1
        expect(company4.reload.vps_earned).to eq 1
      end
    end

    context "when some companies have Company::MAX_VP VPs" do
      before do
        company2.update!(vps_earned: Company::MAX_VP)
        company3.update!(vps_earned: Company::MAX_VP)
      end

      it "updates only company with vps_earned less than Company::MAX_VP VPs" do
        expect(company1.vps_earned).to eq 0
        expect(company2.vps_earned).to eq Company::MAX_VP
        expect(company3.vps_earned).to eq Company::MAX_VP
        expect(company4.vps_earned).to eq 0
        instance.send(:add_company_vps)
        expect(company1.reload.vps_earned).to eq 1
        expect(company2.reload.vps_earned).to eq Company::MAX_VP
        expect(company3.reload.vps_earned).to eq Company::MAX_VP
        expect(company4.reload.vps_earned).to eq 1
      end
    end
  end

  describe "#add_player_vps" do
    context "when the players have less than Company::MAX_VP VPs" do
      it "adds a VP to the player record" do
        instance.send(:add_player_vps)
        expect(player1.reload.vps).to eq 1
        expect(player2.reload.vps).to eq 1
      end
    end

    context "when a player has Company::MAX_VP VPs" do
      before do
        player1.update!(vps: Company::MAX_VP)
      end

      it "updates the player with less than Company::MAX_VP" do
        instance.send(:add_player_vps)
        expect(player2.reload.vps).to eq 1
      end

      it "does not change the player with Company::MAX_VP VPs" do
        expect(player1.reload.vps).to eq Company::MAX_VP
        instance.send(:add_player_vps)
        expect(player1.reload.vps).to eq Company::MAX_VP
      end
    end
  end

  describe "#finalize_battle" do
    let(:winner) { "Allies" }
    before do
      battle.update!(state: "reporting")
    end

    it "updates the battle's winner" do
      instance.send(:finalize_battle, winner)
      expect(battle.reload.winner).to eq winner
    end

    it "sets the battle state to 'final'" do
      instance.send(:finalize_battle, winner)
      expect(battle.reload.final?).to be true
    end
  end
end
