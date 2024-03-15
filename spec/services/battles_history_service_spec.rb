require "rails_helper"

RSpec.describe BattlesHistoryService do
  let!(:ruleset) { create :ruleset }
  let(:faction1) { create :faction }
  let(:doctrine1) { create :doctrine, faction: faction1 }
  let(:faction2) { create :faction, :axis }
  let(:doctrine2) { create :doctrine, faction: faction2 }
  let(:map1) { "6p_brecourt" }
  let(:map2) { "6p_tanteville" }

  let!(:player1) { create :player }
  let!(:player2) { create :player }
  let!(:company1) { create :company, player: player1, ruleset: ruleset }
  let!(:company2) { create :company, player: player2, ruleset: ruleset }
  let!(:final_battle1) { create :battle, :final, :axis_winner, map: map1, ruleset: ruleset }
  let!(:final_battle2) { create :battle, :final, :allied_winner, map: map2, ruleset: ruleset }
  let!(:open_battle) { create :battle, :open, ruleset: ruleset }

  before do
    create :battle_player, battle: final_battle1, player: player1, company: company1
    create :battle_player, :axis, battle: final_battle1, player: player2, company: company2
    create :battle_player, battle: final_battle2, player: player1, company: company1
    create :battle_player, :axis, battle: final_battle2, player: player2, company: company2
  end

  describe "#fetch_battles_history" do
    subject { described_class.fetch_battles_history(ruleset.id) }

    it "returns final battles" do
      battles = subject
      expect(battles.count).to eq 2
      expect(battles.to_a).to match_array([final_battle1, final_battle2])
    end
  end

  describe "#fetch_company_battles_history" do
    subject { described_class.fetch_company_battles_history(company1.id) }

    it "returns final battles" do
      battles = subject
      expect(battles.count).to eq 2
      expect(battles.to_a).to match_array([final_battle1, final_battle2])
    end
  end
end
