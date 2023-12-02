require "rails_helper"

RSpec.describe PlayerRating, type: :model do
  let!(:player_rating) { create :player_rating}

  describe 'associations' do
    it { should belong_to(:player) }
  end
end
