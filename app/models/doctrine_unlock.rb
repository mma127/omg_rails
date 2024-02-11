# == Schema Information
#
# Table name: doctrine_unlocks
#
#  id                                                                    :bigint           not null, primary key
#  branch(Which branch of the doctrine tree this unlock will appear at)  :integer
#  disabled(Is this doctrine unlock disabled?)                           :boolean          default(FALSE), not null
#  internal_description(Doctrine and Unlock names)                       :string
#  row(Which row of the doctrine tree branch this unlock will appear at) :integer
#  tree(Which tree of the doctrine this unlock will appear at)           :integer
#  vp_cost(VP cost of this doctrine unlock)                              :integer          default(0), not null
#  created_at                                                            :datetime         not null
#  updated_at                                                            :datetime         not null
#  doctrine_id                                                           :bigint
#  ruleset_id                                                            :bigint           not null
#  unlock_id                                                             :bigint
#
# Indexes
#
#  index_doctrine_unlocks_on_doctrine_id                (doctrine_id)
#  index_doctrine_unlocks_on_doctrine_id_and_unlock_id  (doctrine_id,unlock_id) UNIQUE
#  index_doctrine_unlocks_on_doctrine_tree              (doctrine_id,tree,branch,row) UNIQUE
#  index_doctrine_unlocks_on_ruleset_id                 (ruleset_id)
#  index_doctrine_unlocks_on_unlock_id                  (unlock_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctrine_id => doctrines.id)
#  fk_rails_...  (ruleset_id => rulesets.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#
class DoctrineUnlock < ApplicationRecord
  belongs_to :doctrine
  belongs_to :unlock
  belongs_to :ruleset
  has_one :restriction

  has_many :restriction_units, through: :restriction
  has_many :restriction_upgrades, through: :restriction
  has_many :restriction_offmaps, through: :restriction

  before_save :generate_internal_description

  def unlock_restriction
    unlock.restriction
  end

  def restrictions
    [restriction, unlock.restriction]
  end

  def enabled_units
    restriction.enabled_units + unlock_restriction.enabled_units
  end

  def disabled_units
    restriction.disabled_units + unlock_restriction.disabled_units
  end

  def unit_swaps
    unlock.unit_swaps
  end

  def enabled_offmaps
    restriction.enabled_offmaps + unlock_restriction.enabled_offmaps
  end

  def enabled_callin_modifiers
    restriction.enabled_callin_modifiers + unlock_restriction.enabled_callin_modifiers
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :doctrine_id, as: :doctrineId
    expose :unlock_id, as: :unlockId
    expose :vp_cost, as: :vpCost
    expose :tree
    expose :branch
    expose :row
    expose :disabled
    expose :unlock, using: Unlock::Entity

    expose :enabled_units, as: :enabledUnits, using: EnabledUnit::Entity, if: { type: :full }
    expose :disabled_units, as: :disabledUnits, using: DisabledUnit::Entity, if: { type: :full }
    expose :unit_swaps, as: :unitSwaps, using: UnitSwap::Entity, if: { type: :full }
    expose :enabled_offmaps, as: :enabledOffmaps, using: EnabledOffmap::Entity, if: { type: :full }
    expose :enabled_callin_modifiers, as: :enabledCallinModifiers, using: EnabledCallinModifier::Entity, if: { type: :full }
  end

  private

  def generate_internal_description
    self.internal_description = "#{doctrine.display_name} | #{unlock.display_name}"
  end
end
