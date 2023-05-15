# == Schema Information
#
# Table name: restriction_upgrades
#
#  id                                                          :bigint           not null, primary key
#  fuel(Fuel cost)                                             :integer
#  internal_description(What does this RestrictionUpgrade do?) :string
#  man(Manpower cost)                                          :integer
#  mun(Munition cost)                                          :integer
#  pop(Population cost)                                        :integer
#  priority(Priority of this restriction)                      :integer
#  type(What effect this restriction has on the upgrade)       :string           not null
#  uses(Number of uses this upgrade provides)                  :integer
#  created_at                                                  :datetime         not null
#  updated_at                                                  :datetime         not null
#  restriction_id                                              :bigint
#  ruleset_id                                                  :bigint
#  upgrade_id                                                  :bigint
#
# Indexes
#
#  idx_restriction_upgrades_ruleset_type_uniq                   (restriction_id,upgrade_id,ruleset_id,type) UNIQUE
#  index_restriction_upgrades_on_restriction_id                 (restriction_id)
#  index_restriction_upgrades_on_ruleset_id                     (ruleset_id)
#  index_restriction_upgrades_on_ruleset_id_and_restriction_id  (ruleset_id,restriction_id)
#  index_restriction_upgrades_on_ruleset_id_and_upgrade_id      (ruleset_id,upgrade_id)
#  index_restriction_upgrades_on_upgrade_id                     (upgrade_id)
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (ruleset_id => rulesets.id)
#  fk_rails_...  (upgrade_id => upgrades.id)
#
require "rails_helper"

RSpec.describe EnabledUpgrade, type: :model do
  let(:restriction) { create :restriction }
  let(:ruleset) { create :ruleset }

  describe 'validations' do
    it { should validate_numericality_of(:man) }
    it { should validate_numericality_of(:mun) }
    it { should validate_numericality_of(:fuel) }
    it { should validate_numericality_of(:pop) }

    context "when the upgrade is a consumable" do
      let(:upgrade) { create :upgrade }
      it "throws a validation error" do
        expect{ EnabledUpgrade.create!(upgrade: upgrade, restriction: restriction, ruleset: ruleset) }
          .to raise_error ActiveRecord::RecordInvalid, "Validation failed: Uses can't be blank, Uses is not a number"
      end
    end

    context "when the upgrade is a building" do
      let(:upgrade) { create :upgrade, type: "Upgrades::Building" }
      it "throws a validation error" do
        expect{ EnabledUpgrade.create!(upgrade: upgrade, restriction: restriction, ruleset: ruleset) }
          .to raise_error ActiveRecord::RecordInvalid, "Validation failed: Uses can't be blank, Uses is not a number"
      end
    end

    context "when the upgrade is a passive" do
      let(:upgrade) { create :upgrade, type: "Upgrades::Passive" }
      it "does not throw an error on nil uses" do
        expect{ EnabledUpgrade.create!(upgrade: upgrade, restriction: restriction, ruleset: ruleset) }
          .not_to raise_error
      end
    end
  end

  it "saves default values for man, mun, fuel, pop" do
    enabled_upgrade = EnabledUpgrade.new
    expect(enabled_upgrade.man).to eq 0
    expect(enabled_upgrade.mun).to eq 0
    expect(enabled_upgrade.fuel).to eq 0
    expect(enabled_upgrade.pop).to eq 0
  end

  it "generates and saves the internal_description" do
    upgrade = create :consumable, display_name: "Medkit"
    restriction = create :restriction, name: "American army"
    ruleset = create :ruleset
    enabled_upgrade = create :enabled_upgrade, restriction: restriction, upgrade: upgrade, ruleset: ruleset
    expect(enabled_upgrade.internal_description).to eq("American army - Medkit")
  end
end


