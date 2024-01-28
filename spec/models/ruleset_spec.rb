# == Schema Information
#
# Table name: rulesets
#
#  id                                                               :bigint           not null, primary key
#  description(Description)                                         :string
#  is_active(Is this ruleset active for its ruleset type?)          :boolean          not null
#  max_resource_bonuses(Company maximum number of resource bonuses) :integer          not null
#  max_vps(Company max vps)                                         :integer          not null
#  name(Ruleset name)                                               :string           not null
#  ruleset_type(Type of ruleset this is)                            :string           not null
#  starting_fuel(Company starting fuel)                             :integer          not null
#  starting_man(Company starting manpower)                          :integer          not null
#  starting_mun(Company starting muntions)                          :integer          not null
#  starting_vps(Company starting vps)                               :integer          not null
#  created_at                                                       :datetime         not null
#  updated_at                                                       :datetime         not null
#
# Indexes
#
#  index_rulesets_on_ruleset_type_and_is_active  (ruleset_type,is_active)
#
require "rails_helper"

RSpec.describe Ruleset, type: :model do
  let!(:ruleset) { create :ruleset }

  describe 'associations' do
    it { should have_many(:doctrine_unlocks) }
    it { should have_many(:restriction_units) }
    it { should have_many(:restriction_upgrades) }
    it { should have_many(:restriction_offmaps) }
    it { should have_many(:restriction_callin_modifiers) }
    it { should have_many(:resource_bonuses) }
    it { should have_many(:companies) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:starting_man) }
    it { should validate_presence_of(:starting_mun) }
    it { should validate_presence_of(:starting_fuel) }
    it { should validate_presence_of(:starting_vps) }
    it { should validate_presence_of(:max_vps) }
    it { should validate_presence_of(:max_resource_bonuses) }
    it { should validate_numericality_of(:starting_man) }
    it { should validate_numericality_of(:starting_mun) }
    it { should validate_numericality_of(:starting_fuel) }
    it { should validate_numericality_of(:starting_vps) }
    it { should validate_numericality_of(:max_vps) }
    it { should validate_numericality_of(:max_resource_bonuses) }

    describe "is_active" do
      before do
        Ruleset.destroy_all
      end

      context "when the previous ruleset is not active for the same type" do
        before do
          create :ruleset, is_active: false, ruleset_type: Ruleset.ruleset_types[:war]
        end

        it "does not fail validation when creating a new Ruleset of the same ruleset_type with is_active false" do
          ruleset = create :ruleset, is_active: false, ruleset_type: Ruleset.ruleset_types[:war]
          expect(ruleset).to be_valid
        end

        it "does not fail validation when creating a new Ruleset of the same ruleset_type with is_active true" do
          ruleset = create :ruleset, is_active: true, ruleset_type: Ruleset.ruleset_types[:war]
          expect(ruleset).to be_valid
        end
      end

      context "when there is already a ruleset with is_active true" do
        before do
          create :ruleset, is_active: true, ruleset_type: Ruleset.ruleset_types[:war]
        end

        it "does not fail validation when creating a new Ruleset of the same ruleset_type with is_active false" do
          ruleset = create :ruleset, is_active: false, ruleset_type: Ruleset.ruleset_types[:war]
          expect(ruleset).to be_valid
        end

        context "creating a new Ruleset of the same ruleset_type with is_active true" do
          it "fails validation" do
            ruleset = build :ruleset, is_active: true, ruleset_type: Ruleset.ruleset_types[:war]
            expect(ruleset).not_to be_valid
          end

          it "raises an error" do
            expect { create :ruleset, is_active: true, ruleset_type: Ruleset.ruleset_types[:war] }
              .to raise_error(
                    ActiveRecord::RecordInvalid, "Validation failed: Is active has already been taken"
                  )
          end
        end
      end
    end
  end
end


