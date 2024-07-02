# == Schema Information
#
# Table name: offmaps
#
#  id                                                                       :bigint           not null, primary key
#  ability_rgd(ability_rgd_name)                                            :string
#  buffs(Description of buffs this offmap grants)                           :string
#  const_name(Offmap const name for battlefile)                             :string           not null
#  cooldown(Cooldown between uses, in seconds)                              :integer
#  debuffs(Description of debuffs this offmap inflicts)                     :string
#  description(Offmap description)                                          :string           not null
#  disabled(override that disables the offmap from being purchased or used) :boolean          default(FALSE), not null
#  display_name(Offmap display name)                                        :string           not null
#  duration(Offmap duration in seconds)                                     :integer
#  name(Offmap name)                                                        :string           not null
#  shells_fired(Number of shells fired during the offmap)                   :integer
#  unlimited_uses(Whether this offmap has limited or unlimited uses)        :boolean          not null
#  upgrade_rgd(upgrade rgd name)                                            :string
#  weapon_rgd(Weapon rgd name)                                              :string
#  created_at                                                               :datetime         not null
#  updated_at                                                               :datetime         not null
#  ruleset_id                                                               :bigint           not null
#
# Indexes
#
#  index_offmaps_on_name_and_ruleset_id  (name,ruleset_id) UNIQUE
#  index_offmaps_on_ruleset_id           (ruleset_id)
#
# Foreign Keys
#
#  fk_rails_...  (ruleset_id => rulesets.id)
#
class Offmap < ApplicationRecord
  belongs_to :ruleset
  has_many :available_offmaps

  scope :active, -> { where(disabled: false) }

  validates :name, uniqueness: { scope: :ruleset_id }

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :display_name, as: :displayName
    expose :description
    expose :cooldown
    expose :duration
    expose :unlimited_uses, as: :unlimitedUses
    expose :buffs
    expose :debuffs
    expose :weapon_rgd, as: :weaponRgd
    expose :shells_fired, as: :shellsFired
  end
end
