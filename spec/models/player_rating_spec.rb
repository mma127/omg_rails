# == Schema Information
#
# Table name: player_ratings
#
#  id                                                 :bigint           not null, primary key
#  elo(trueskill mu normalized between 1000 and 2000) :integer
#  last_played(last played match)                     :date
#  mu(trueskill mu)                                   :decimal(, )
#  sigma(trueskill sigma)                             :decimal(, )
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  player_id                                          :bigint
#
# Indexes
#
#  index_player_ratings_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (player_id => players.id)
#
require "rails_helper"

RSpec.describe PlayerRating, type: :model do
  let!(:player_rating) { create :player_rating}

  describe 'associations' do
    it { should belong_to(:player) }
  end

  describe "#from_historical" do
    let!(:player) { create :player }
    let(:elo) { 1400 }
    let(:mu) { 24.3484584 }
    let(:sigma) { 4.294785963 }
    let(:last_played) { "2023-04-01" }
    let!(:hpr) { create :historical_player_rating, player_name: player.name, player: nil, elo: elo, mu: mu, sigma: sigma, last_played: last_played }

    subject { described_class.from_historical(player, hpr) }

    it "is created with hpr values" do
      expect(subject.player).to eq player
      expect(subject.elo).to eq elo
      expect(subject.mu).to eq mu
      expect(subject.sigma).to eq sigma
      expect(subject.last_played).to eq Date.parse(last_played)
    end
  end

  describe "#for_new_player" do
    let!(:player) { create :player }

    subject { described_class.for_new_player(player) }

    it "is created with default values" do
      expect(subject.player).to eq player
      expect(subject.elo).to eq PlayerRating::DEFAULT_ELO
      expect(subject.mu).to eq PlayerRating::DEFAULT_MU
      expect(subject.sigma).to eq PlayerRating::DEFAULT_SIGMA
      expect(subject.last_played).to be nil
    end
  end
end
