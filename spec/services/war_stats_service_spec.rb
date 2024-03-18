require "rails_helper"
require "support/time_helpers"

RSpec.describe WarStatsService do
  let!(:ruleset) { create :ruleset }
  let!(:amer) { create :faction }
  let!(:wehr) { create :faction, :axis }
  let!(:inf) { create :doctrine, faction: amer }
  let!(:armor) { create :doctrine, faction: amer }
  let!(:blitz) { create :doctrine, faction: wehr }
  let!(:ter) { create :doctrine, faction: wehr }

  describe "#fetch_stats" do
    subject { described_class.fetch_stats(ruleset.id) }

    before do
      create :historical_battle_player, ruleset: ruleset, faction: amer, doctrine: inf, is_winner: true, battle_id: 1
      create :historical_battle_player, ruleset: ruleset, faction: amer, doctrine: armor, is_winner: true, battle_id: 1
      create :historical_battle_player, ruleset: ruleset, faction: wehr, doctrine: ter, is_winner: false, battle_id: 1
      create :historical_battle_player, ruleset: ruleset, faction: wehr, doctrine: blitz, is_winner: false, battle_id: 1

      create :historical_battle_player, ruleset: ruleset, faction: wehr, doctrine: ter, is_winner: true, battle_id: 2
      create :historical_battle_player, ruleset: ruleset, faction: wehr, doctrine: ter, is_winner: true, battle_id: 2
      create :historical_battle_player, ruleset: ruleset, faction: amer, doctrine: inf, is_winner: false, battle_id: 2
      create :historical_battle_player, ruleset: ruleset, faction: amer, doctrine: inf, is_winner: false, battle_id: 2
    end

    it "returns stats" do
      result = subject

      expect(result[:doctrines].size).to eq 4
      expect(result[:factions].size).to eq 2
      expect(result[:allied_wins]).to eq 1
      expect(result[:axis_wins]).to eq 1
    end

    it "returns doctrine stats" do
      result = subject
      doctrine_stats = result[:doctrines]

      inf_stats = doctrine_stats.find { |ds| ds.model_name == inf.name }
      expect(inf_stats.model_id).to eq inf.id
      expect(inf_stats.wins).to eq 1
      expect(inf_stats.losses).to eq 2
      expect(inf_stats.win_rate).to eq 0.3333

      armor_stats = doctrine_stats.find { |ds| ds.model_name == armor.name }
      expect(armor_stats.model_id).to eq armor.id
      expect(armor_stats.wins).to eq 1
      expect(armor_stats.losses).to eq 0
      expect(armor_stats.win_rate).to eq 1

      blitz_stats = doctrine_stats.find { |ds| ds.model_name == blitz.name }
      expect(blitz_stats.model_id).to eq blitz.id
      expect(blitz_stats.wins).to eq 0
      expect(blitz_stats.losses).to eq 1
      expect(blitz_stats.win_rate).to eq 0

      ter_stats = doctrine_stats.find { |ds| ds.model_name == ter.name }
      expect(ter_stats.model_id).to eq ter.id
      expect(ter_stats.wins).to eq 2
      expect(ter_stats.losses).to eq 1
      expect(ter_stats.win_rate).to eq 0.6667
    end

    it "returns faction stats" do
      result = subject
      faction_stats = result[:factions]

      amer_stats = faction_stats.find { |ds| ds.model_name == amer.name }
      expect(amer_stats.model_id).to eq amer.id
      expect(amer_stats.wins).to eq 2
      expect(amer_stats.losses).to eq 2
      expect(amer_stats.win_rate).to eq 0.5

      wehr_stats = faction_stats.find { |ds| ds.model_name == wehr.name }
      expect(wehr_stats.model_id).to eq wehr.id
      expect(wehr_stats.wins).to eq 2
      expect(wehr_stats.losses).to eq 2
      expect(wehr_stats.win_rate).to eq 0.5
    end
  end
end
