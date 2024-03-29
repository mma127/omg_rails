# == Schema Information
#
# Table name: offmaps
#
#  id                                                                :bigint           not null, primary key
#  ability_rgd(ability_rgd_name)                                     :string
#  buffs(Description of buffs this offmap grants)                    :string
#  const_name(Offmap const name for battlefile)                      :string           not null
#  cooldown(Cooldown between uses, in seconds)                       :integer
#  debuffs(Description of debuffs this offmap inflicts)              :string
#  description(Offmap description)                                   :string           not null
#  display_name(Offmap display name)                                 :string           not null
#  duration(Offmap duration in seconds)                              :integer
#  name(Offmap name)                                                 :string           not null
#  shells_fired(Number of shells fired during the offmap)            :integer
#  unlimited_uses(Whether this offmap has limited or unlimited uses) :boolean          not null
#  upgrade_rgd(upgrade rgd name)                                     :string
#  weapon_rgd(Weapon rgd name)                                       :string
#  created_at                                                        :datetime         not null
#  updated_at                                                        :datetime         not null
#
class Offmap < ApplicationRecord
  has_many :available_offmaps

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
