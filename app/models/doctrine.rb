# == Schema Information
#
# Table name: doctrines
#
#  id                                                           :bigint           not null, primary key
#  const_name(Doctrine CONST name for battlefile)               :string
#  display_name(Display name)                                   :string
#  internal_name(Name for internal code use, may not be needed) :string
#  name(Raw name)                                               :string
#  created_at                                                   :datetime         not null
#  updated_at                                                   :datetime         not null
#  faction_id                                                   :bigint
#
# Indexes
#
#  index_doctrines_on_faction_id  (faction_id)
#
# Foreign Keys
#
#  fk_rails_...  (faction_id => factions.id)
#
class Doctrine < ApplicationRecord
  include ActiveModel::Serializers::JSON

  belongs_to :faction, inverse_of: :doctrines
  has_many :doctrine_unlocks
  has_many :unlocks, through: :doctrine_unlocks
  has_many :restrictions
end
