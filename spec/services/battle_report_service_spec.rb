require "rails_helper"

RSpec.describe BattleReportService do
  let!(:player1) { create :player }
  let!(:player2) { create :player }
  let(:ruleset) { create :ruleset }
  let(:max_vps) { ruleset.max_vps }
  let(:size) { 1 }
  let!(:battle) { create :battle, ruleset: ruleset, state: "ingame", size: size }
  let(:unit1) { create :unit }
  let(:unit2) { create :unit }

  let!(:company1) { create :active_company, player: player1, ruleset: ruleset }
  let!(:company2) { create :active_company, player: player2, ruleset: ruleset }
  let!(:available_unit1) { create :available_unit, unit: unit1, company: company1, available: 10, resupply: 5, resupply_max: 10, company_max: 10 }
  let!(:available_unit2) { create :available_unit, unit: unit2, company: company2, available: 80, resupply: 10, resupply_max: 99, company_max: 99 }
  let!(:squad11) { create :squad, available_unit: available_unit1, company: company1 }
  let!(:squad12) { create :squad, available_unit: available_unit1, company: company1, vet: 20 }
  let!(:squad21) { create :squad, available_unit: available_unit2, company: company2 }
  let!(:squad22) { create :squad, available_unit: available_unit2, company: company2, vet: 45 }
  let!(:squad23) { create :squad, available_unit: available_unit2, company: company2, tab_category: "infantry", category_position: 2 }
  let!(:squad23) { create :squad, available_unit: available_unit2, company: company2, tab_category: "infantry", category_position: 2 }
  let!(:battle_player1) { create :battle_player, battle: battle, player: player1, company: company1 }
  let!(:battle_player2) { create :battle_player, battle: battle, player: player2, company: company2 }

  let(:update_service_double) { instance_double("Ratings::UpdateService", update_player_ratings: nil) }
  let(:historical_player_service_double) { instance_double("HistoricalBattlePlayerService", create_historical_battle_players_for_battle: nil) }
  let(:report_parse_service_double) { instance_double("BattleReportStats::ReportParseService", process_battle_stats: nil) }

  subject(:instance) { described_class.new(battle.id) }

  before do
    allow(Ratings::UpdateService).to receive(:new).and_return(update_service_double)
    allow(HistoricalBattlePlayerService).to receive(:new).and_return(historical_player_service_double)
    allow(BattleReportStats::ReportParseService).to receive(:new).and_return(report_parse_service_double)
  end

  describe "#process_report" do
    let(:race_winner) { "Allies" }
    let(:dead_squads_str) { "#{squad12.id};#{squad22.id}" }
    let(:surviving_squads) { "#{squad11.id},1.0;#{squad21.id},5.0" }
    let(:is_final) { 1 }
    let(:dropped_players) { "" }
    let(:time_elapsed) { 600 }

    subject(:process_report) { instance.process_report(battle.id, is_final, player1.name, time_elapsed,
                                                       race_winner, "",
                                                       dead_squads_str, surviving_squads, dropped_players, {}) }

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
        expect(available_unit1.reload.available).to eq 8 # company max of 10 - 2 squads
        expect(available_unit2.reload.available).to eq 89
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
        expect(battle.reload.winner).to eq Battle.winners[:allied]
        expect(battle.final?).to be true
      end

      it "calls battle report stats" do
        expect(report_parse_service_double).to receive(:process_battle_stats).once
        process_report
      end

      context "when an available_unit has only surviving squads" do
        let!(:available_unit1) { create :available_unit, unit: unit1, company: company1, available: 0, resupply: 1, resupply_max: 1, company_max: 2 }
        let(:dead_squads_str) { "#{squad22.id}" }
        let(:surviving_squads) { "#{squad11.id},1.0;#{squad12.id}, 0.0;#{squad21.id},5.0" }

        it "updates availability" do
          process_report
          expect(available_unit1.reload.available).to eq 0 # company max of 2 - 2 squads
          expect(available_unit2.reload.available).to eq 89
        end
      end

      context "when battle size is one" do
        it "does not call rating update service" do
          expect(update_service_double).not_to receive(:update_player_ratings)
          process_report
        end

        it "does not call historical player service" do
          expect(historical_player_service_double).not_to receive(:create_historical_battle_players_for_battle)
          process_report
        end
      end

      context "when battle size is larger than one" do
        let(:size) { 4 }

        it "calls rating update service" do
          expect(update_service_double).to receive(:update_player_ratings).once
          process_report
        end

        it "calls historical player service" do
          expect(historical_player_service_double).to receive(:create_historical_battle_players_for_battle).once
          process_report
        end
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

    context "when there is a dropped player but battle is not final" do
      let(:is_final) { 0 }
      let(:dropped_players) { "#{player2.name}; " }

      it "does not finalize the battle" do
        process_report
        expect(battle.reload.ingame?).to be true
        expect(battle.winner).to eq nil
      end

      it "sets the dropped flag on battle player 2" do
        process_report
        expect(battle_player2.reload.is_dropped).to be true
      end
    end

    context "when there is a dropped player and battle is final" do
      let(:is_final) { 1 }
      let(:dropped_players) { "#{player2.name}; " }

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
        expect(available_unit1.reload.available).to eq 8
        expect(available_unit2.reload.available).to eq 89
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
        expect(battle.reload.winner).to eq Battle.winners[:allied]
        expect(battle.final?).to be true
      end

      it "calls battle report stats" do
        expect(report_parse_service_double).to receive(:process_battle_stats).once
        process_report
      end
    end

    context "when the battle reports before the minimum threshold" do
      let(:time_elapsed) { 200 }

      it "sets the battle's state to abandoned" do
        process_report
        expect(battle.reload.abandoned?).to be true
        expect(battle.winner).to eq nil
      end

      it "does not change company values" do
        process_report
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
        process_report
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

    context "when the surviving squad's given vet is less than what it had at the start" do
      let(:surviving_squads) { "#{squad11.id},0.0;" }

      before do
        squad11.update!(vet: 100)
      end

      it "does not change the surviving squad's vet" do
        instance.send(:update_surviving_squads, starting_squads_by_id, surviving_squads)
        expect(squad11.reload.vet).to eq 100
      end
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

    context "when there is 0 available" do
      before do
        available_unit1.update!(available: 0)
      end

      it "only adds the resupply amount to available" do
        instance.send(:add_company_availability, company1)
        expect(available_unit1.reload.available).to eq 5
      end
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

  describe "#reconcile_company_unit_available" do
    # Simulates post-resupply update of availability given 2 surviving squads of this available unit
    let!(:available_unit1) { create :available_unit, unit: unit1, company: company1, available: 1, resupply: 1, resupply_max: 1, company_max: 2 }

    subject { instance.send(:reconcile_company_unit_available, company1) }

    it "sets available to 0" do
      subject
      expect(available_unit1.reload.available).to eq 0
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

    context "when there are resource bonuses" do
      let(:man_rb) { create :resource_bonus, resource: "man", man: 100, mun: -10, fuel: -15, ruleset: ruleset }
      let(:mun_rb) { create :resource_bonus, resource: "mun", man: -50, mun: 40, fuel: -10, ruleset: ruleset }
      let(:fuel_rb) { create :resource_bonus, resource: "fuel", man: -60, mun: -20, fuel: 50, ruleset: ruleset }
      before do
        create :company_resource_bonus, company: company1, resource_bonus: man_rb
        create :company_resource_bonus, company: company1, resource_bonus: man_rb
        create :company_resource_bonus, company: company1, resource_bonus: mun_rb

        create :company_resource_bonus, company: company2, resource_bonus: mun_rb
        create :company_resource_bonus, company: company2, resource_bonus: fuel_rb
      end

      it "updates the company resources" do
        instance.send(:recalculate_company_resources)
        expect(company1.reload.man).to eq ruleset.starting_man - (available_unit1.man * 2) + (man_rb.man * 2) + mun_rb.man
        expect(company1.mun).to eq ruleset.starting_mun - (available_unit1.mun * 2) + (man_rb.mun * 2) + mun_rb.mun
        expect(company1.fuel).to eq ruleset.starting_fuel - (available_unit1.fuel * 2) + (man_rb.fuel * 2) + mun_rb.fuel

        expect(company2.reload.man).to eq ruleset.starting_man - (available_unit2.man * 3) + mun_rb.man + fuel_rb.man
        expect(company2.mun).to eq ruleset.starting_mun - (available_unit2.mun * 3) + mun_rb.mun + fuel_rb.mun
        expect(company2.fuel).to eq ruleset.starting_fuel - (available_unit2.fuel * 3) + mun_rb.fuel + fuel_rb.fuel
      end
    end
  end

  describe "#add_company_vps" do
    let!(:company3) { create :active_company, player: player1, ruleset: ruleset }
    let!(:company4) { create :active_company, player: player2, ruleset: ruleset }

    context "when all companies have less than max_vps VPs" do
      it "updates all company vps_earned" do
        instance.send(:add_company_vps)
        expect(company1.reload.vps_earned).to eq 1
        expect(company1.vps_current).to eq 1
        expect(company2.reload.vps_earned).to eq 1
        expect(company2.vps_current).to eq 1
        expect(company3.reload.vps_earned).to eq 1
        expect(company3.vps_current).to eq 1
        expect(company4.reload.vps_earned).to eq 1
        expect(company4.vps_current).to eq 1
      end
    end

    context "when some companies have max_vps VPs" do
      before do
        company2.update!(vps_earned: max_vps)
        company3.update!(vps_earned: max_vps)
      end

      it "updates only company with vps_earned less than max_vps VPs" do
        expect(company1.vps_earned).to eq 0
        expect(company2.vps_earned).to eq max_vps
        expect(company3.vps_earned).to eq max_vps
        expect(company4.vps_earned).to eq 0
        instance.send(:add_company_vps)
        expect(company1.reload.vps_earned).to eq 1
        expect(company1.vps_current).to eq 1
        expect(company2.reload.vps_earned).to eq max_vps
        expect(company2.vps_current).to eq 0
        expect(company3.reload.vps_earned).to eq max_vps
        expect(company3.vps_current).to eq 0
        expect(company4.reload.vps_earned).to eq 1
        expect(company4.vps_current).to eq 1
      end
    end
  end

  describe "#add_player_vps" do
    context "when the players have less than max_vps VPs" do
      it "adds a VP to the player record" do
        instance.send(:add_player_vps)
        expect(player1.reload.vps).to eq 1
        expect(player1.total_vps_earned).to eq 1
        expect(player2.reload.vps).to eq 1
        expect(player2.total_vps_earned).to eq 1
      end
    end

    context "when a player has max_vps VPs" do
      before do
        player1.update!(vps: max_vps, total_vps_earned: max_vps)
      end

      it "updates the player with less than max_vps" do
        instance.send(:add_player_vps)
        expect(player2.reload.vps).to eq 1
        expect(player2.total_vps_earned).to eq 1
      end

      it "updates the total_vps_earned but not vps for the player with max_vps VPs" do
        expect(player1.reload.vps).to eq max_vps
        instance.send(:add_player_vps)
        expect(player1.reload.vps).to eq max_vps
        expect(player1.total_vps_earned).to eq (max_vps + 1)
      end
    end
  end

  describe "#finalize_battle" do
    let(:winner) { Battle.winners[:allied] }
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

  describe "#handle_dropped_players" do
    context "when the string is empty" do
      let(:dropped_players) { "" }

      it "does nothing" do
        instance.send(:handle_dropped_players, dropped_players)
        expect(battle_player1.reload.is_dropped).to be false
        expect(battle_player2.reload.is_dropped).to be false
      end
    end

    context "when there are dropped players" do
      let(:dropped_players) { "#{player2.name}; " }

      it "updates the battle player is_dropped flag" do
        instance.send(:handle_dropped_players, dropped_players)
        expect(battle_player2.reload.is_dropped).to be true
      end
    end
  end
end
