# == Schema Information
#
# Table name: restriction_upgrades
#
#  id                                                               :bigint           not null, primary key
#  fuel(Fuel cost)                                                  :integer
#  internal_description(What does this RestrictionUpgrade do?)      :string
#  man(Manpower cost)                                               :integer
#  max(Maximum number of purchases per unit)                        :integer
#  mun(Munition cost)                                               :integer
#  pop(Population cost)                                             :integer
#  priority(Priority of this restriction)                           :integer
#  type(What effect this restriction has on the upgrade)            :string           not null
#  unitwide_upgrade_slots(Upgrade slot cost for unit wide upgrades) :integer
#  upgrade_slots(Upgrade slot cost for per model upgrades)          :integer
#  uses(Number of uses this upgrade provides)                       :integer
#  created_at                                                       :datetime         not null
#  updated_at                                                       :datetime         not null
#  restriction_id                                                   :bigint
#  ruleset_id                                                       :bigint
#  upgrade_id                                                       :bigint
#
# Indexes
#
#  idx_restriction_upgrades_ruleset_type_uniq                   (restriction_id,upgrade_id,ruleset_id,type,uses,max,man,mun,fuel) UNIQUE
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
class DisabledUpgrade < RestrictionUpgrade
  before_save :generate_internal_description

  private

  def generate_internal_description
    self.internal_description = "#{restriction.name} - #{upgrade.display_name} - DISABLED"
  end
end
