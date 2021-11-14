# == Schema Information
#
# Table name: unit_modifications
#
#  id                                                                                           :bigint           not null, primary key
#  callin_modifier(Replaces base callin modifier if not 1)                                      :decimal(, )
#  company_max(Modified company max)                                                            :integer
#  const_name(Replacement const name for the unit used by the battle file)                      :string
#  fuel(Modified fuel cost)                                                                     :integer
#  is_airdrop(Replacement flag for whether the unit can airdrop)                                :boolean
#  is_infiltrate(Replacement flag for whether the unit can infiltrate)                          :boolean
#  man(Modified manpower cost)                                                                  :integer
#  mun(Modified munition cost)                                                                  :integer
#  pop(Modified population cost)                                                                :integer
#  priority(Priority order to apply the modification from 1 -> 100)                             :integer
#  resupply(Modified resupply per game)                                                         :integer
#  type(Type of modification)                                                                   :string
#  unitwide_upgrade_slots(Modified number of slots available for unit wide weapon replacements) :integer
#  upgrade_slots(Modified number of slots available for per model weapon upgrades)              :integer
#  created_at                                                                                   :datetime         not null
#  updated_at                                                                                   :datetime         not null
#  doctrine_id                                                                                  :bigint
#  faction_id                                                                                   :bigint
#  unit_id                                                                                      :bigint
#  unlock_id                                                                                    :bigint
#
# Indexes
#
#  index_unit_modifications_on_doctrine_id  (doctrine_id)
#  index_unit_modifications_on_faction_id   (faction_id)
#  index_unit_modifications_on_unit_id      (unit_id)
#  index_unit_modifications_on_unlock_id    (unlock_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctrine_id => doctrines.id)
#  fk_rails_...  (faction_id => factions.id)
#  fk_rails_...  (unit_id => units.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#
class UnitModification < ApplicationRecord
  belongs_to :unit
  belongs_to :faction, optional: true
  belongs_to :doctrine, optional: true
  belongs_to :unlock, optional: true
end
