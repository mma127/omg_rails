# == Schema Information
#
# Table name: restrictions
#
#  id                                             :bigint           not null, primary key
#  description(Restriction description)           :text
#  name(Restriction name)                         :string
#  vet_requirement(Minimum veterancy requirement) :integer
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#  doctrine_id                                    :bigint
#  faction_id                                     :bigint
#  unlock_id                                      :bigint
#
# Indexes
#
#  index_restrictions_on_doctrine_id  (doctrine_id)
#  index_restrictions_on_faction_id   (faction_id)
#  index_restrictions_on_unlock_id    (unlock_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctrine_id => doctrines.id)
#  fk_rails_...  (faction_id => factions.id)
#  fk_rails_...  (unlock_id => unlocks.id)
#
class Restriction < ApplicationRecord
  belongs_to :faction, optional: true
  belongs_to :doctrine, optional: true
  belongs_to :unlock, optional: true

  has_many :unit_modifications
  has_many :upgrade_modifications
  has_many :restriction_units
  has_many :units, through: :restriction_units
  has_many :restriction_offmaps
  has_many :offmaps, through: :restriction_offmaps
  has_many :restriction_callin_modifiers
  has_many :callin_modifiers, through: :restriction_callin_modifiers
end
