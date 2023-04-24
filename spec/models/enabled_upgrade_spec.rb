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

  describe 'validations' do
    it { should validate_numericality_of(:man) }
    it { should validate_numericality_of(:mun) }
    it { should validate_numericality_of(:fuel) }
    it { should validate_numericality_of(:pop) }
    it { should validate_numericality_of(:uses) }
  end


  it "generates and saves the internal_description" do
    upgrade = create :consumable, display_name: "Medkit"
    restriction = create :restriction, name: "American army"
    ruleset = create :ruleset
    enabled_upgrade = create :enabled_upgrade, restriction: restriction, upgrade: upgrade, ruleset: ruleset
    expect(enabled_upgrade.internal_description).to eq("American army - Medkit")
  end
end


