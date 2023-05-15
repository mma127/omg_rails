# == Schema Information
#
# Table name: upgrade_swap_units
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  unit_id         :bigint           not null
#  upgrade_swap_id :bigint           not null
#
# Indexes
#
#  index_upgrade_swap_units_on_unit_id                      (unit_id)
#  index_upgrade_swap_units_on_upgrade_swap_id              (upgrade_swap_id)
#  index_upgrade_swap_units_on_upgrade_swap_id_and_unit_id  (upgrade_swap_id,unit_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (unit_id => units.id)
#  fk_rails_...  (upgrade_swap_id => upgrade_swaps.id)
#
FactoryBot.define do
  factory :upgrade_swap_unit do
    association :upgrade_swap
    association :unit
  end
end
