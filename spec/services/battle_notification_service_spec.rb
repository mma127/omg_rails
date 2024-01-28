require "rails_helper"

RSpec.describe BattleNotificationService do
  let(:player1_discord) { 123456 }
  let!(:player1) { create :player, discord_id: player1_discord }
  let!(:player2) { create :player }
  let(:ruleset) { create :ruleset }
  let!(:battle) { create :battle, ruleset: ruleset, state: "ingame", size: 1 }

  before do
    create :battle_player, battle: battle, player: player1, ruleset: ruleset
    create :battle_player, battle: battle, player: player2, ruleset: ruleset
  end

  describe "#notify_battle_full" do
    subject { described_class.new(battle.id).notify_battle_full }

    context "when the battle can be notified" do
      let(:expected_message) { "Game #{battle.id} is full.\n<@#{player1_discord}> #{player2.name}" }

      it "calls the DiscordService" do
        expect(DiscordService).to receive(:notify_looking_for_game).with(expected_message)
        subject

        expect(battle.reload.last_notified).not_to be nil
      end
    end

    context "when the battle was notified recently" do
      before do
        battle.update!(last_notified: Time.current)
      end

      it "does not call the DiscordService" do
        expect(DiscordService).not_to receive(:notify_looking_for_game)
        subject
      end
    end
  end
end
