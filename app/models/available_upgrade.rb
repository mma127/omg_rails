# == Schema Information
#
# Table name: available_upgrades
#
#  id                                                               :bigint           not null, primary key
#  fuel(Calculated fuel cost of this upgrade for the company)       :integer          not null
#  man(Calculated man cost of this upgrade for the company)         :integer          not null
#  max(Maximum number of this upgrade purchasable by a unit)        :integer
#  mun(Calculated mun cost of this upgrade for the company)         :integer          not null
#  pop(Calculated pop cost of this upgrade for the company)         :decimal(, )      not null
#  type(Type of available upgrade)                                  :string           not null
#  unitwide_upgrade_slots(Upgrade slot cost for unit wide upgrades) :integer
#  upgrade_slots(Upgrade slot cost for per model upgrades)          :integer
#  uses(Uses of this upgrade)                                       :integer
#  created_at                                                       :datetime         not null
#  updated_at                                                       :datetime         not null
#  company_id                                                       :bigint
#  unit_id                                                          :bigint
#  upgrade_id                                                       :bigint
#
# Indexes
#
#  idx_available_upgrade_uniq              (company_id,upgrade_id,unit_id,type) UNIQUE
#  index_available_upgrades_on_company_id  (company_id)
#  index_available_upgrades_on_unit_id     (unit_id)
#  index_available_upgrades_on_upgrade_id  (upgrade_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (unit_id => units.id)
#  fk_rails_...  (upgrade_id => upgrades.id)
#
class AvailableUpgrade < ApplicationRecord
  belongs_to :company
  belongs_to :upgrade, inverse_of: :available_upgrades
  belongs_to :unit

  has_many :squad_upgrades, dependent: :destroy

  def upgrade_name
    upgrade.name
  end

  def upgrade_display_name
    upgrade.display_name
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :company_id, as: :companyId
    expose :upgrade_id, as: :upgradeId
    expose :upgrade_name, as: :upgradeName
    expose :upgrade_display_name, as: :upgradeDisplayName
    expose :unit_id, as: :unitId
    expose :type
    expose :uses
    expose :man
    expose :mun
    expose :fuel
    expose :pop
    expose :max
    expose :upgrade_slots, as: :upgradeSlots
    expose :unitwide_upgrade_slots, as: :unitwideUpgradeSlots

    expose :upgrade, using: Upgrade::Entity, if: { type: :include_upgrade }
  end
end
