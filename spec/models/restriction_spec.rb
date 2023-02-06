# == Schema Information
#
# Table name: restrictions
#
#  id                                             :bigint           not null, primary key
#  description(Restriction description)           :text
#  name(Restriction name)                         :string
#  vet_requirement(Minimum veterancy requirement) :integer
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#  doctrine_id                                    :bigint
#  doctrine_unlock_id                             :bigint
#  faction_id                                     :bigint
#  unlock_id                                      :bigint
#
# Indexes
#
#  idx_restrictions_uniq_id                  (faction_id,doctrine_id,doctrine_unlock_id,unlock_id) UNIQUE
#  index_restrictions_on_doctrine_id         (doctrine_id)
#  index_restrictions_on_doctrine_unlock_id  (doctrine_unlock_id)
#  index_restrictions_on_faction_id          (faction_id)
#  index_restrictions_on_unlock_id           (unlock_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctrine_id => doctrines.id)
#  fk_rails_...  (doctrine_unlock_id => doctrine_unlocks.id)
#  fk_rails_...  (faction_id => factions.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#
require "rails_helper"

RSpec.describe Restriction, type: :model do
  let!(:restriction) { create :restriction }

  describe 'associations' do
    it { should belong_to(:faction).optional }
    it { should belong_to(:doctrine).optional }
    it { should belong_to(:unlock).optional }
    it { should have_many(:restriction_units) }
    it { should have_many(:units) }
    it { should have_many(:restriction_upgrades) }
    it { should have_many(:upgrades) }
    it { should have_many(:restriction_offmaps) }
    it { should have_many(:offmaps) }
    it { should have_many(:restriction_callin_modifiers) }
    it { should have_many(:callin_modifiers) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  context "validate only_one_of_faction_doctrine_unlock" do
    let(:faction) { create :faction }
    let(:doctrine) { create :doctrine }
    let(:unlock) { create :unlock }

    it "is invalid to have neither faction, doctrine, or unlock" do
      restriction = Restriction.new(name: "name")
      expect(restriction).not_to be_valid
    end

    it "is invalid to have both faction and doctrine" do
      restriction = Restriction.new(name: "name", faction: faction, doctrine: doctrine)
      expect(restriction).not_to be_valid
    end

    it "is invalid to have both faction and unlock" do
      restriction = Restriction.new(name: "name", faction: faction, unlock: unlock)
      expect(restriction).not_to be_valid
    end

    it "is invalid to have both doctrine and unlock" do
      restriction = Restriction.new(name: "name", doctrine: doctrine, unlock: unlock)
      expect(restriction).not_to be_valid
    end
  end

  context "traits" do
    context "default" do
      it "has non-null faction" do
        expect(restriction.faction.present?).to be true
        expect(restriction.doctrine.present?).to be false
        expect(restriction.doctrine_unlock.present?).to be false
        expect(restriction.unlock.present?).to be false
      end
    end

    context "with_doctrine" do
      let!(:doctrine) { create :doctrine }
      let!(:restriction) { create :restriction, :with_doctrine, doctrine: doctrine }

      it "has non-null doctrine" do
        expect(restriction.faction.present?).to be false
        expect(restriction.doctrine.present?).to be true
        expect(restriction.doctrine_unlock.present?).to be false
        expect(restriction.unlock.present?).to be false
      end

      it "has the specified doctrine" do
        expect(restriction.doctrine).to eq doctrine
      end
    end

    context "with_doctrine_unlock" do
      let!(:doctrine_unlock) { create :doctrine_unlock }
      let!(:restriction) { create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock }

      it "has non-null doctrine_unlock" do
        expect(restriction.faction.present?).to be false
        expect(restriction.doctrine.present?).to be false
        expect(restriction.doctrine_unlock.present?).to be true
        expect(restriction.unlock.present?).to be false
      end

      it "has the specified doctrine_unlock" do
        expect(restriction.doctrine_unlock).to eq doctrine_unlock
      end
    end

    context "with_unlock" do
      let!(:unlock) { create :unlock }
      let!(:restriction) { create :restriction, :with_unlock, unlock: unlock }

      it "has non-null unlock" do
        expect(restriction.faction.present?).to be false
        expect(restriction.doctrine.present?).to be false
        expect(restriction.doctrine_unlock.present?).to be false
        expect(restriction.unlock.present?).to be true
      end

      it "has the specified unlock" do
        expect(restriction.unlock).to eq unlock
      end
    end
  end
end


