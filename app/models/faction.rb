# == Schema Information
#
# Table name: factions
#
#  id                                                           :bigint           not null, primary key
#  const_name(Faction CONST name for battlefile)                :string
#  display_name(Display name)                                   :string
#  internal_name(Name for internal code use, may not be needed) :string
#  name(Raw name)                                               :string
#  side(Allied or Axis side)                                    :string
#  created_at                                                   :datetime         not null
#  updated_at                                                   :datetime         not null
#
class Faction < ApplicationRecord
  has_many :doctrines, inverse_of: :faction
  has_many :restrictions

  enum side: {
    allied: "allies",
    axis: "axis"
  }
end
