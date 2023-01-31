# == Schema Information
#
# Table name: restriction_upgrades
#
#  id                                                    :bigint           not null, primary key
#  description(What does this RestrictionUpgrade do?)    :string
#  fuel(Fuel cost)                                       :integer
#  man(Manpower cost)                                    :integer
#  mun(Munition cost)                                    :integer
#  pop(Population cost)                                  :integer
#  priority(Priority of this restriction)                :integer
#  type(What effect this restriction has on the upgrade) :string           not null
#  uses(Number of uses this upgrade provides)            :integer
#  created_at                                            :datetime         not null
#  updated_at                                            :datetime         not null
#  restriction_id                                        :bigint
#  ruleset_id                                            :bigint
#  upgrade_id                                            :bigint
#
# Indexes
#
#  index_restriction_upgrades_on_restriction_id  (restriction_id)
#  index_restriction_upgrades_on_ruleset_id      (ruleset_id)
#  index_restriction_upgrades_on_upgrade_id      (upgrade_id)
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (ruleset_id => rulesets.id)
#  fk_rails_...  (upgrade_id => upgrades.id)
#
require "rails_helper"

RSpec.describe DisabledUpgrade, type: :model do

  it "generates and saves the description" do
    upgrade = create :upgrade, display_name: "Medkit"
    restriction = create :restriction, name: "American army"
    ruleset = create :ruleset
    disabled_upgrade = create :disabled_upgrade, restriction: restriction, upgrade: upgrade, ruleset: ruleset
    expect(disabled_upgrade.description).to eq("American army - Medkit - DISABLED")
  end
end
