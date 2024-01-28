require "rails_helper"
require "support/time_helpers"

RSpec.describe HistoricalBattlePlayerService do
  let!(:ruleset) { create :ruleset }
  let(:winner) { Battle.winners[:allied] }
  let!(:battle) { create :battle, state: :final, winner: winner, size: 2, ruleset: ruleset }

  let!(:player1) { create :player }
  let!(:pr1) { create :player_rating, player: player1, elo: 1800, mu: 29, sigma: 4, wins: 5, losses: 0 }
  let!(:company1) { create :company, player: player1, ruleset: ruleset }
  let!(:bp1) { create :battle_player, battle: battle, player: player1, company: company1, side: BattlePlayer.sides[:allied] }

  let!(:player2) { create :player }
  let!(:pr2) { create :player_rating, player: player2, elo: 1304, mu: 19, sigma: 1, wins: 10, losses: 34 }
  let!(:company2) { create :company, player: player2, ruleset: ruleset }
  let!(:bp2) { create :battle_player, battle: battle, player: player2, company: company2, side: BattlePlayer.sides[:allied] }

  let!(:player3) { create :player }
  let!(:pr3) { create :player_rating, player: player3, elo: 1560, mu: 24, sigma: 2.3, wins: 7, losses: 8 }
  let!(:company3) { create :company, player: player3, ruleset: ruleset }
  let!(:bp3) { create :battle_player, battle: battle, player: player3, company: company3, side: BattlePlayer.sides[:axis] }

  let!(:player4) { create :player }
  let!(:pr4) { create :player_rating, player: player4, elo: 1619, mu: 26, sigma: 1, wins: 2, losses: 2 }
  let!(:company4) { create :company, player: player4, ruleset: ruleset }
  let!(:bp4) { create :battle_player, battle: battle, player: player4, company: company4, side: BattlePlayer.sides[:axis] }

  let(:expected_date) { DateTime.parse("2023-12-12").to_date }

  before do
    travel_to DateTime.parse("2023-12-12")
  end

  after do
    travel_back
  end

  describe "#create_historical_battle_players_for_battle" do
    subject { described_class.new(battle.id).create_historical_battle_players_for_battle }

    it "creates HistoricalBattlePlayers" do
      expect { subject }.to change { HistoricalBattlePlayer.count }.by 4
    end

    it "creates a HBP for player 1" do
      subject

      hbp = HistoricalBattlePlayer.find_by(player: player1, battle_id: battle.id)
      expect(hbp.player_name).to eq player1.name
      expect(hbp.faction).to eq company1.faction
      expect(hbp.doctrine).to eq company1.doctrine
      expect(hbp.is_winner).to be true
      expect(hbp.elo).to eq pr1.elo
      expect(hbp.mu).to eq pr1.mu
      expect(hbp.sigma).to eq pr1.sigma
      expect(hbp.wins).to eq pr1.wins
      expect(hbp.losses).to eq pr1.losses
      expect(hbp.date).to eq expected_date
    end

    it "creates a HBP for player 2" do
      subject

      hbp = HistoricalBattlePlayer.find_by(player: player2, battle_id: battle.id)
      expect(hbp.player_name).to eq player2.name
      expect(hbp.faction).to eq company2.faction
      expect(hbp.doctrine).to eq company2.doctrine
      expect(hbp.is_winner).to be true
      expect(hbp.elo).to eq pr2.elo
      expect(hbp.mu).to eq pr2.mu
      expect(hbp.sigma).to eq pr2.sigma
      expect(hbp.wins).to eq pr2.wins
      expect(hbp.losses).to eq pr2.losses
      expect(hbp.date).to eq expected_date
    end

    it "creates a HBP for player 3" do
      subject

      hbp = HistoricalBattlePlayer.find_by(player: player3, battle_id: battle.id)
      expect(hbp.player_name).to eq player3.name
      expect(hbp.faction).to eq company3.faction
      expect(hbp.doctrine).to eq company3.doctrine
      expect(hbp.is_winner).to be false
      expect(hbp.elo).to eq pr3.elo
      expect(hbp.mu).to eq pr3.mu
      expect(hbp.sigma).to eq pr3.sigma
      expect(hbp.wins).to eq pr3.wins
      expect(hbp.losses).to eq pr3.losses
      expect(hbp.date).to eq expected_date
    end

    it "creates a HBP for player 4" do
      subject

      hbp = HistoricalBattlePlayer.find_by(player: player4, battle_id: battle.id)
      expect(hbp.player_name).to eq player4.name
      expect(hbp.faction).to eq company4.faction
      expect(hbp.doctrine).to eq company4.doctrine
      expect(hbp.is_winner).to be false
      expect(hbp.elo).to eq pr4.elo
      expect(hbp.mu).to eq pr4.mu
      expect(hbp.sigma).to eq pr4.sigma
      expect(hbp.wins).to eq pr4.wins
      expect(hbp.losses).to eq pr4.losses
      expect(hbp.date).to eq expected_date
    end
  end
end
