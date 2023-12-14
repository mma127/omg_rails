require "rails_helper"

RSpec.describe BattleReportStats::ReportParseService do
  let!(:player1) { create :player }
  let!(:player2) { create :player }
  let(:ruleset) { create :ruleset }
  let(:state) { "final" }
  let(:size) { 1 }
  let!(:battle) { create :battle, ruleset: ruleset, state: state, size: size, winner: "allied" }

  let!(:company1) { create :company, player: player1, ruleset: ruleset }
  let!(:company2) { create :company, player: player2, ruleset: ruleset }
  let!(:company_stats1) { create :company_stats, company: company1 }
  let!(:company_stats2) { create :company_stats, company: company2 }

  let(:update_service_double1) { instance_double("BattleReportStats::UpdateService") }
  let(:update_service_double2) { instance_double("BattleReportStats::UpdateService") }

  before do
    create :battle_player, battle: battle, player: player1, company: company1, side: "allied"
    create :battle_player, battle: battle, player: player2, company: company2, side: "axis"
    allow(BattleReportStats::UpdateService).to receive(:new).with(company1.id).and_return(update_service_double1)
    allow(BattleReportStats::UpdateService).to receive(:new).with(company2.id).and_return(update_service_double2)
  end

  describe "#process_battle_stats" do
    let(:inf_lost1) { 24 }
    let(:veh_lost1) { 3 }
    let(:inf_killed1) { 56 }
    let(:veh_killed1) { 1 }
    let(:inf_lost2) { 56 }
    let(:veh_lost2) { 1 }
    let(:inf_killed2) { 24 }
    let(:veh_killed2) { 3 }

    let(:stats_string) { "#{player1.name},CompanyId:#{company1.id},Inf Lost:#{inf_lost1} ,Vehicles Lost:#{veh_lost1} ,Inf Killed:#{inf_killed1} ,Vehicles Killed:#{veh_killed1};
#{player2.name},CompanyId:#{company2.id},Inf Lost:#{inf_lost2} ,Vehicles Lost:#{veh_lost2} ,Inf Killed:#{inf_killed2} ,Vehicles Killed:#{veh_killed2}" }

    context "when battle is final" do
      subject { described_class.new(battle.id, stats_string).process_battle_stats }

      it "calls the update service for the winner" do
        expect(update_service_double1).to receive(:update_company_stats).with(
          size,
          {
            inf_lost: inf_lost1,
            vehicles_lost: veh_lost1,
            inf_killed: inf_killed1,
            vehicles_killed: veh_killed1
          },
          true,
          true)
        allow(update_service_double2).to receive(:update_company_stats)

        subject
      end

      it "calls the update service for the winner" do
        allow(update_service_double1).to receive(:update_company_stats)
        expect(update_service_double2).to receive(:update_company_stats).with(
          size,
          {
            inf_lost: inf_lost2,
            vehicles_lost: veh_lost2,
            inf_killed: inf_killed2,
            vehicles_killed: veh_killed2
          },
          true,
          false)

        subject
      end
    end
    context "when battle is not final" do
      let(:state) { "ingame" }

      subject { described_class.new(battle.id, stats_string).process_battle_stats }

      it "calls the update service for the winner" do
        expect(update_service_double1).to receive(:update_company_stats).with(
          size,
          {
            inf_lost: inf_lost1,
            vehicles_lost: veh_lost1,
            inf_killed: inf_killed1,
            vehicles_killed: veh_killed1
          },
          false,
          true)
        allow(update_service_double2).to receive(:update_company_stats)

        subject
      end

      it "calls the update service for the winner" do
        allow(update_service_double1).to receive(:update_company_stats)
        expect(update_service_double2).to receive(:update_company_stats).with(
          size,
          {
            inf_lost: inf_lost2,
            vehicles_lost: veh_lost2,
            inf_killed: inf_killed2,
            vehicles_killed: veh_killed2
          },
          false,
          false)

        subject
      end
    end
  end
end
