require "rails_helper"

RSpec.describe BattleReportStats::UpdateService do
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

  let(:inf_lost1) { 24 }
  let(:veh_lost1) { 3 }
  let(:inf_killed1) { 56 }
  let(:veh_killed1) { 1 }
  let(:inf_lost2) { 56 }
  let(:veh_lost2) { 1 }
  let(:inf_killed2) { 24 }
  let(:veh_killed2) { 3 }

  let(:new_stats) { {
    inf_killed: inf_killed,
    vehicles_killed: vehicles_killed,
    inf_lost: inf_lost,
    vehicles_lost: vehicles_lost
  } }

  describe "#update_company_stats" do
    subject { described_class.new(company_id).update_company_stats(size, new_stats, is_final, is_winner) }

    context "when battle is final" do
      let(:is_final) { true }

      context "when the company is the winner" do
        let(:company_id) { company1.id }
        let(:is_winner) { true }
        let(:inf_killed) { inf_killed1 }
        let(:vehicles_killed) { veh_killed1 }
        let(:inf_lost) { inf_lost1 }
        let(:vehicles_lost) { veh_lost1 }

        it "updates infantry and vehicle kill loss" do
          subject

          expect(company_stats1.reload.infantry_kills_1v1).to eq inf_killed1
          expect(company_stats1.vehicle_kills_1v1).to eq veh_killed1
          expect(company_stats1.infantry_losses_1v1).to eq inf_lost1
          expect(company_stats1.vehicle_losses_1v1).to eq veh_lost1
        end

        it "updates wins and streak" do
          subject

          expect(company_stats1.reload.wins_1v1).to eq 1
          expect(company_stats1.reload.streak_1v1).to eq 1
          expect(company_stats1.reload.losses_1v1).to eq 0
        end

        context "when there are existing stats" do

          let!(:company_stats1) { create :company_stats, company: company1,
                                         infantry_kills_1v1: 542, vehicle_kills_1v1: 21,
                                         infantry_losses_1v1: 239, vehicle_losses_1v1: 12,
                                         wins_1v1: 4, streak_1v1: 3, losses_1v1: 2 }

          it "updates infantry and vehicle kill loss" do
            subject

            expect(company_stats1.reload.infantry_kills_1v1).to eq inf_killed1 + 542
            expect(company_stats1.vehicle_kills_1v1).to eq veh_killed1 + 21
            expect(company_stats1.infantry_losses_1v1).to eq inf_lost1 + 239
            expect(company_stats1.vehicle_losses_1v1).to eq veh_lost1 + 12
          end

          it "updates wins and streak" do
            subject

            expect(company_stats1.reload.wins_1v1).to eq 5
            expect(company_stats1.reload.streak_1v1).to eq 4
            expect(company_stats1.reload.losses_1v1).to eq 2
          end
        end
      end

      context "when the company is the loser" do
        let(:company_id) { company2.id }
        let(:is_winner) { false }
        let(:inf_killed) { inf_killed2 }
        let(:vehicles_killed) { veh_killed2 }
        let(:inf_lost) { inf_lost2 }
        let(:vehicles_lost) { veh_lost2 }

        it "updates infantry and vehicle kill loss" do
          subject

          expect(company_stats2.reload.infantry_kills_1v1).to eq inf_killed2
          expect(company_stats2.vehicle_kills_1v1).to eq veh_killed2
          expect(company_stats2.infantry_losses_1v1).to eq inf_lost2
          expect(company_stats2.vehicle_losses_1v1).to eq veh_lost2
        end

        it "updates wins and streak" do
          subject

          expect(company_stats2.reload.wins_1v1).to eq 0
          expect(company_stats2.reload.streak_1v1).to eq 0
          expect(company_stats2.reload.losses_1v1).to eq 1
        end
      end
    end
    context "when battle is not final" do
      let(:is_final) { false }

      context "when the company is the winner" do
        let(:company_id) { company1.id }
        let(:is_winner) { true }
        let(:inf_killed) { inf_killed1 }
        let(:vehicles_killed) { veh_killed1 }
        let(:inf_lost) { inf_lost1 }
        let(:vehicles_lost) { veh_lost1 }

        it "updates infantry and vehicle kill loss" do
          subject

          expect(company_stats1.reload.infantry_kills_1v1).to eq inf_killed1
          expect(company_stats1.vehicle_kills_1v1).to eq veh_killed1
          expect(company_stats1.infantry_losses_1v1).to eq inf_lost1
          expect(company_stats1.vehicle_losses_1v1).to eq veh_lost1
        end

        it "does not update wins and streak" do
          subject

          expect(company_stats1.reload.wins_1v1).to eq 0
          expect(company_stats1.reload.streak_1v1).to eq 0
          expect(company_stats1.reload.losses_1v1).to eq 0
        end
      end

      context "when the company is the loser" do
        let(:company_id) { company2.id }
        let(:is_winner) { false }
        let(:inf_killed) { inf_killed2 }
        let(:vehicles_killed) { veh_killed2 }
        let(:inf_lost) { inf_lost2 }
        let(:vehicles_lost) { veh_lost2 }

        it "updates infantry and vehicle kill loss" do
          subject

          expect(company_stats2.reload.infantry_kills_1v1).to eq inf_killed2
          expect(company_stats2.vehicle_kills_1v1).to eq veh_killed2
          expect(company_stats2.infantry_losses_1v1).to eq inf_lost2
          expect(company_stats2.vehicle_losses_1v1).to eq veh_lost2
        end

        it "does not update wins and streak" do
          subject

          expect(company_stats2.reload.wins_1v1).to eq 0
          expect(company_stats2.reload.streak_1v1).to eq 0
          expect(company_stats2.reload.losses_1v1).to eq 0
        end
      end
    end
  end
end
