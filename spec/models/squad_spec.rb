require "rails_helper"

RSpec.describe Squad, type: :model do
  let!(:squad) { create :squad}

  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:available_unit) }
    it { should have_many(:squad_upgrades) }
    it { should have_many(:upgrades) }
  end

  describe 'validations' do
    it { should validate_presence_of(:company) }
    it { should validate_presence_of(:vet) }
    it { should validate_presence_of(:tab_category) }
    it { should validate_presence_of(:category_position) }
    it { should validate_numericality_of(:vet) }
    it { should validate_numericality_of(:category_position) }
  end
end
