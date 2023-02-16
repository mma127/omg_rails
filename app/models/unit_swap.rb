# == Schema Information
#
# Table name: unit_swaps
#
#  id                                                          :bigint           not null, primary key
#  internal_description(Internal description of this UnitSwap) :string
#  created_at                                                  :datetime         not null
#  updated_at                                                  :datetime         not null
#  new_unit_id                                                 :bigint           not null
#  old_unit_id                                                 :bigint           not null
#  unlock_id                                                   :bigint           not null
#
# Indexes
#
#  index_unit_swaps_on_new_unit_id                (new_unit_id)
#  index_unit_swaps_on_old_unit_id                (old_unit_id)
#  index_unit_swaps_on_unlock_id                  (unlock_id)
#  index_unit_swaps_on_unlock_id_and_new_unit_id  (unlock_id,new_unit_id) UNIQUE
#  index_unit_swaps_on_unlock_id_and_old_unit_id  (unlock_id,old_unit_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (new_unit_id => units.id)
#  fk_rails_...  (old_unit_id => units.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#
class UnitSwap < ApplicationRecord
  belongs_to :unlock
  belongs_to :old_unit, class_name: "Unit"
  belongs_to :new_unit, class_name: "Unit"

  before_save :generate_internal_description

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :unlock_id
    expose :old_unit, as: :oldUnit, using: Unit::Entity
    expose :new_unit, as: :newUnit, using: Unit::Entity
  end

  private

  def generate_internal_description
    self.internal_description = "#{unlock.display_name} | #{old_unit.display_name} -> #{new_unit.display_name}"
  end
end
