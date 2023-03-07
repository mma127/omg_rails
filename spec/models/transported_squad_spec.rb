# == Schema Information
#
# Table name: transported_squads
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  embarked_squad_id  :bigint           not null
#  transport_squad_id :bigint           not null
#
# Indexes
#
#  idx_transported_squads_assoc_uniq               (transport_squad_id,embarked_squad_id) UNIQUE
#  idx_transported_squads_embarked_squad_uniq      (embarked_squad_id) UNIQUE
#  index_transported_squads_on_embarked_squad_id   (embarked_squad_id)
#  index_transported_squads_on_transport_squad_id  (transport_squad_id)
#
# Foreign Keys
#
#  fk_rails_...  (embarked_squad_id => squads.id)
#  fk_rails_...  (transport_squad_id => squads.id)
#
require "rails_helper"

RSpec.describe TransportedSquad, type: :model do
  let!(:transported_squad) { create :transported_squad }

  describe 'associations' do
    it { should belong_to(:transport_squad) }
    it { should belong_to(:embarked_squad) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:embarked_squad) }
  end

  describe "imports" do
    let!(:transport1) { create :squad }
    let!(:transport2) { create :squad }
    let!(:passenger1) { create :squad }
    let!(:passenger2) { create :squad }
    let!(:passenger3) { create :squad }
    let!(:transported_squad1) { create :transported_squad, transport_squad: transport1, embarked_squad: passenger1 }

    it "makes no changes when importing a TransportedSquad with the same transport_squad and embarked_squad as an existing record" do
      transported_squads = [TransportedSquad.new(transport_squad: transport1, embarked_squad: passenger1)]
      expect { TransportedSquad.import!(transported_squads, on_duplicate_key_ignore: { conflict_target: [:transport_squad_id, :embarked_squad_id] }) }
        .to change { TransportedSquad.count }.by(0)
      expect(TransportedSquad.exists?(transported_squad1.id)).to be true
    end

    it "creates additional TransportedSquads" do
      transported_squads = [TransportedSquad.new(transport_squad: transport1, embarked_squad: passenger1),
                            TransportedSquad.new(transport_squad: transport1, embarked_squad: passenger2),
                            TransportedSquad.new(transport_squad: transport2, embarked_squad: passenger3)]
      expect { TransportedSquad.import!(transported_squads, on_duplicate_key_ignore: { conflict_target: [:transport_squad_id, :embarked_squad_id] }) }
        .to change { TransportedSquad.count }.by(2)
      expect(TransportedSquad.exists?(transported_squad1.id)).to be true
      expect(TransportedSquad.find_by(transport_squad: transport1, embarked_squad: passenger2).present?).to be true
      expect(TransportedSquad.find_by(transport_squad: transport2, embarked_squad: passenger3).present?).to be true
    end
  end
end

