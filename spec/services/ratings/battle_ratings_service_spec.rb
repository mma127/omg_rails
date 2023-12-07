require "rails_helper"

RSpec.describe Ratings::BattleRatingsService do
  let!(:player1) { create :player }
  let(:elo1) { 1500 }
  let!(:player1_rating) { create :player_rating, player: player1, elo: elo1 }
  let!(:player2) { create :player }
  let(:elo2) { 1500 }
  let!(:player2_rating) { create :player_rating, player: player2, elo: elo2 }
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

  let(:size) { 1 }
  let!(:battle) { create :battle, size: size }

  describe "#get_elo_difference" do
    subject { described_class.new(battle).get_elo_difference }
    context "with 1v1 battle" do
      before do
        create :battle_player, battle: battle, player: player1
        create :battle_player, :axis, battle: battle, player: player2
      end

      context "when elos are matched" do
        it "returns 0" do
          expect(subject).to eq 0
        end
      end

      context "when allies are favored" do
        let(:elo1) { 1770 }
        it "returns a positive value" do
          expect(subject).to eq 270
        end
      end

      context "when axis are favored" do
        let(:elo2) { 1800 }
        it "returns a negative value" do
          expect(subject).to eq -300
        end
      end
    end

    context "with 4v4 battle" do
      before do
        create :battle_player, battle: battle, player: player1
        create :battle_player, battle: battle, player: player2
        create :battle_player, battle: battle, player: player3
        create :battle_player, battle: battle, player: player4
        create :battle_player, :axis, battle: battle, player: player5
        create :battle_player, :axis, battle: battle, player: player6
        create :battle_player, :axis, battle: battle, player: player7
        create :battle_player, :axis, battle: battle, player: player8
      end

      context "when elos are matched" do
        it "returns 0" do
          expect(subject).to eq 0
        end
      end

      context "when allies are favored" do
        let(:elo1) { 1600 }
        let(:elo8) { 1250 }
        it "returns a positive value" do
          expect(subject).to eq 88
        end
      end

      context "when axis are favored" do
        let(:elo2) { 1400 }
        let(:elo6) { 1800 }
        it "returns a negative value" do
          expect(subject).to eq -100
        end
      end
    end
  end

  describe "#find_most_balanced_teams" do
    subject { described_class.new(battle).find_most_balanced_teams }

    context "with 2v2" do
      let(:size) { 2 }
      let!(:bp1) { create :battle_player, battle: battle, player: player1 }
      let!(:bp2) { create :battle_player, battle: battle, player: player2 }
      let!(:bp3) { create :battle_player, :axis, battle: battle, player: player3 }
      let!(:bp4) { create :battle_player, :axis, battle: battle, player: player4 }

      context "when there is zero elo diff" do
        let(:elo1) { 1800 }
        let(:elo2) { 1800 }
        let(:elo3) { 1200 }
        let(:elo4) { 1200 }

        it "returns balanced teams" do
          elo_diff, team1, team2 = subject

          expect(elo_diff).to eq 0
          expect(team1).to match_array [bp1, bp3]
          expect(team2).to match_array [bp2, bp4]
        end

        it "persists the results" do
          subject

          expect(battle.reload.elo_diff).to eq 0
          expect(bp1.reload.team_balance).to eq 1
          expect(bp2.reload.team_balance).to eq 2
          expect(bp3.reload.team_balance).to eq 1
          expect(bp4.reload.team_balance).to eq 2
        end
      end

      context "when there is non-zero elo diff" do
        let(:elo1) { 1800 }
        let(:elo2) { 1100 }
        let(:elo3) { 1200 }
        let(:elo4) { 1300 }

        it "returns balanced teams" do
          elo_diff, team1, team2 = subject

          expect(elo_diff).to eq 200
          expect(team1).to match_array [bp1, bp2]
          expect(team2).to match_array [bp3, bp4]
        end

        it "persists the results" do
          subject

          expect(battle.reload.elo_diff).to eq 200
          expect(bp1.reload.team_balance).to eq 1
          expect(bp2.reload.team_balance).to eq 1
          expect(bp3.reload.team_balance).to eq 2
          expect(bp4.reload.team_balance).to eq 2
        end
      end
    end

    context "with 4v4" do
      let(:size) { 4 }
      let!(:bp1) { create :battle_player, battle: battle, player: player1 }
      let!(:bp2) { create :battle_player, battle: battle, player: player2 }
      let!(:bp3) { create :battle_player, battle: battle, player: player3 }
      let!(:bp4) { create :battle_player, battle: battle, player: player4 }
      let!(:bp5) { create :battle_player, :axis, battle: battle, player: player5 }
      let!(:bp6) { create :battle_player, :axis, battle: battle, player: player6 }
      let!(:bp7) { create :battle_player, :axis, battle: battle, player: player7 }
      let!(:bp8) { create :battle_player, :axis, battle: battle, player: player8 }

      context "when there is zero elo diff" do
        let(:elo1) { 1800 }
        let(:elo2) { 1800 }
        let(:elo3) { 1200 }
        let(:elo4) { 1200 }
        let(:elo5) { 1500 }
        let(:elo6) { 1500 }
        let(:elo7) { 1400 }
        let(:elo8) { 1400 }

        it "returns balanced teams" do
          elo_diff, team1, team2 = subject

          expect(elo_diff).to eq 0
          expect(team1).to match_array [bp1, bp3, bp5, bp7]
          expect(team2).to match_array [bp2, bp4, bp6, bp8]
        end

        it "persists the results" do
          subject

          expect(battle.reload.elo_diff).to eq 0
          expect(bp1.reload.team_balance).to eq 1
          expect(bp2.reload.team_balance).to eq 2
          expect(bp3.reload.team_balance).to eq 1
          expect(bp4.reload.team_balance).to eq 2
          expect(bp5.reload.team_balance).to eq 1
          expect(bp6.reload.team_balance).to eq 2
          expect(bp7.reload.team_balance).to eq 1
          expect(bp8.reload.team_balance).to eq 2
        end
      end

      context "when there is non-zero elo diff" do
        let(:elo1) { 1800 }
        let(:elo2) { 1100 }
        let(:elo3) { 1200 }
        let(:elo4) { 1220 }
        let(:elo5) { 1565 }
        let(:elo6) { 1356 }
        let(:elo7) { 1635 }
        let(:elo8) { 1400 }

        it "returns balanced teams" do
          elo_diff, team1, team2 = subject

          expect(elo_diff).to eq 9
          expect(team1).to match_array [bp1, bp2, bp6, bp8]
          expect(team2).to match_array [bp3, bp4, bp5, bp7]
        end

        it "persists the results" do
          subject

          expect(battle.reload.elo_diff).to eq 9
          expect(bp1.reload.team_balance).to eq 1
          expect(bp2.reload.team_balance).to eq 1
          expect(bp3.reload.team_balance).to eq 2
          expect(bp4.reload.team_balance).to eq 2
          expect(bp5.reload.team_balance).to eq 2
          expect(bp6.reload.team_balance).to eq 1
          expect(bp7.reload.team_balance).to eq 2
          expect(bp8.reload.team_balance).to eq 1
        end
      end
    end
  end

end
