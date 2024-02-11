require "rails_helper"

RSpec.describe BattleReportStats::UpdateService do
  let!(:player1) { create :player }
  let!(:player2) { create :player }
  let(:ruleset) { create :ruleset }
  let(:state) { "final" }
  let(:size) { 1 }
  let!(:battle) { create :battle, ruleset: ruleset, state: state, size: size, winner: "allied" }

  let!(:company1) { create :active_company, player: player1, ruleset: ruleset }
  let!(:company2) { create :active_company, player: player2, ruleset: ruleset }
  let(:prev_inf_killed_2v2) { 100 }
  let(:prev_veh_lost_2v2) { 7 }
  let!(:company_stats1) { create :company_stats, company: company1,
                                 infantry_kills_2v2: prev_inf_killed_2v2, vehicle_losses_2v2: prev_veh_lost_2v2 }
  let!(:company_stats2) { create :company_stats, company: company2 }

  let!(:squad1) { create :squad, company: company1, ruleset: ruleset, vet: 100 }
  let!(:squad2) { create :squad, company: company1, ruleset: ruleset, vet: 0 }
  let!(:squad3) { create :squad, company: company1, ruleset: ruleset, vet: 42.12385 }

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

          cls = CompanyLeaderboardStats.find_by(company_id: company1.id)
          expect(company_stats1.reload.infantry_kills_1v1).to eq inf_killed1
          expect(cls.total_infantry_kills).to eq inf_killed1 + prev_inf_killed_2v2
          expect(company_stats1.vehicle_kills_1v1).to eq veh_killed1
          expect(cls.total_vehicle_kills).to eq veh_killed1
          expect(company_stats1.infantry_losses_1v1).to eq inf_lost1
          expect(cls.total_infantry_losses).to eq inf_lost1
          expect(company_stats1.vehicle_losses_1v1).to eq veh_lost1
          expect(cls.total_vehicle_losses).to eq veh_lost1 + prev_veh_lost_2v2

          expect(cls.total_unit_kills).to eq inf_killed1 + prev_inf_killed_2v2 + veh_killed1
          expect(cls.total_unit_losses).to eq inf_lost1 + veh_lost1 + prev_veh_lost_2v2
        end

        it "updates wins and streak" do
          subject

          expect(company_stats1.reload.wins_1v1).to eq 1
          expect(company_stats1.streak_1v1).to eq 1
          expect(company_stats1.losses_1v1).to eq 0
        end

        it "updates company total exp" do
          subject

          expect(CompanyLeaderboardStats.find_by(company_id: company1.id).total_exp).to eq 142.12385
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
            expect(company_stats1.streak_1v1).to eq 4
            expect(company_stats1.losses_1v1).to eq 2
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
          expect(company_stats2.streak_1v1).to eq 0
          expect(company_stats2.losses_1v1).to eq 1
        end

        it "updates company total exp when there are no squads" do
          subject

          expect(CompanyLeaderboardStats.find_by(company_id: company2.id).total_exp).to eq 0
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
          expect(company_stats1.streak_1v1).to eq 0
          expect(company_stats1.losses_1v1).to eq 0
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
          expect(company_stats2.streak_1v1).to eq 0
          expect(company_stats2.losses_1v1).to eq 0
        end
      end
    end
  end
end
