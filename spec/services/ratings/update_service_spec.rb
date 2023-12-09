require "rails_helper"
require "support/time_helpers"

RSpec.describe Ratings::UpdateService do
  let!(:player1) { create :player }
  let(:elo1) { 1500 }
  let(:mu1) { 25 }
  let(:sigma1) { 8.33333 }
  let!(:player1_rating) { create :player_rating, player: player1, elo: elo1, mu: mu1, sigma: sigma1 }
  let!(:player2) { create :player }
  let(:elo2) { 1500 }
  let(:mu2) { 25 }
  let(:sigma2) { 8.33333 }
  let!(:player2_rating) { create :player_rating, player: player2, elo: elo2, mu: mu2, sigma: sigma2 }
  let!(:player3) { create :player }
  let(:elo3) { 1500 }
  let!(:player3_rating) { create :player_rating, player: player3, elo: elo3 }
  let!(:player4) { create :player }
  let(:elo4) { 1500 }
  let!(:player4_rating) { create :player_rating, player: player4, elo: elo4 }
  let!(:player5) { create :player }
  let(:elo5) { 1500 }
  let!(:player5_rating) { create :player_rating, player: player5, elo: elo5 }
  let!(:player6) { create :player }
  let(:elo6) { 1500 }
  let!(:player6_rating) { create :player_rating, player: player6, elo: elo6 }
  let!(:player7) { create :player }
  let(:elo7) { 1500 }
  let!(:player7_rating) { create :player_rating, player: player7, elo: elo7 }
  let!(:player8) { create :player }
  let(:elo8) { 1500 }
  let!(:player8_rating) { create :player_rating, player: player8, elo: elo8 }

  let(:date_now) { DateTime.now.to_date }
  let(:size) { 1 }
  let!(:battle) { create :battle, size: size }

  describe "#update_player_ratings" do
    let(:winner) { Battle.winners[:allied] }

    subject { described_class.new(battle.id).update_player_ratings(winner) }

    before do
      travel_to Time.now
    end

    after do
      travel_back
    end

    context "with 1v1 battle" do
      before do
        create :battle_player, battle: battle, player: player1
        create :battle_player, :axis, battle: battle, player: player2
      end

      context "with equal starting rating" do
        context "with allied winner" do
          it "updates player ratings" do
            subject

            expect(player1_rating.reload.elo).to eq 2000
            expect(player1_rating.mu).to eq 29.39582964471032
            expect(player1_rating.sigma).to eq 7.171473132334705
            expect(player2_rating.reload.elo).to eq 1000
            expect(player2_rating.mu).to eq 20.604170355289675
            expect(player2_rating.sigma).to eq 7.171473132334705
          end

          it "updates player win loss" do
            subject

            expect(player1_rating.reload.wins).to eq 1
            expect(player1_rating.losses).to eq 0
            expect(player1_rating.last_played).to eq date_now
            expect(player2_rating.reload.wins).to eq 0
            expect(player2_rating.losses).to eq 1
            expect(player2_rating.last_played).to eq date_now
          end

          context "when there are bounding player ratings" do
            before do
              create :player_rating, mu: 40
              create :player_rating, mu: 10
            end

            it "updates player ratings" do
              subject

              expect(player1.player_rating.reload.elo).to eq 1646
              expect(player1_rating.mu).to eq 29.39582964471032
              expect(player1_rating.sigma).to eq 7.171473132334705
              expect(player2.player_rating.reload.elo).to eq 1353
              expect(player2_rating.mu).to eq 20.604170355289675
              expect(player2_rating.sigma).to eq 7.171473132334705
            end
          end
        end

        context "with axis winner" do
          let(:winner) { Battle.winners[:axis] }

          it "updates player ratings" do
            subject

            expect(player1_rating.reload.elo).to eq 1000
            expect(player1_rating.mu).to eq 20.604170355289675
            expect(player1_rating.sigma).to eq 7.171473132334705
            expect(player2_rating.reload.elo).to eq 2000
            expect(player2_rating.mu).to eq 29.39582964471032
            expect(player2_rating.sigma).to eq 7.171473132334705
          end

          it "updates player win loss" do
            subject

            expect(player1_rating.reload.wins).to eq 0
            expect(player1_rating.losses).to eq 1
            expect(player1_rating.last_played).to eq date_now
            expect(player2_rating.reload.wins).to eq 1
            expect(player2_rating.losses).to eq 0
            expect(player2_rating.last_played).to eq date_now
          end

          context "when there are bounding player ratings" do
            before do
              create :player_rating, mu: 40
              create :player_rating, mu: 10
            end

            it "updates player ratings" do
              subject

              expect(player1.player_rating.reload.elo).to eq 1353
              expect(player2.player_rating.reload.elo).to eq 1646
            end
          end
        end

        context "with pre-existing elo" do
          let(:elo1) { 1773 }
          let(:elo2) { 1773 }
          let(:mu1) { 27.234 }
          let(:mu2) { 27.234 }

          context "when sigma is large" do
            it "updates player ratings" do
              subject

              expect(player1.player_rating.reload.elo).to eq 2000
              expect(player1_rating.mu).to eq 31.629829644710316
              expect(player1_rating.sigma).to eq 7.171473132334705
              expect(player2.player_rating.reload.elo).to eq 1000
              expect(player2_rating.mu).to eq 22.83817035528968
              expect(player2_rating.sigma).to eq 7.171473132334705
            end
          end

          context "when sigma is small" do
            let(:sigma1) { 1.341234 }
            let(:sigma2) { 1.2345 }

            it "updates player ratings" do
              subject

              expect(player1.player_rating.reload.elo).to eq 2000
              expect(player1_rating.mu).to eq 27.490374599177066
              expect(player1_rating.sigma).to eq 1.3225477969814246
              expect(player2.player_rating.reload.elo).to eq 1809
              expect(player2_rating.mu).to eq 27.016655205212224
              expect(player2_rating.sigma).to eq 1.2207250526942424
            end
          end
        end
      end

      context "with differing starting ratings" do

      end
    end
  end
end
