# == Schema Information
#
# Table name: offmaps
#
#  id                                           :bigint           not null, primary key
#  const_name(Offmap const name for battlefile) :string
#  description(Offmap description)              :string
#  display_name(Offmap display name)            :string
#  name(Offmap name)                            :string
#  created_at                                   :datetime         not null
#  updated_at                                   :datetime         not null
#
class Offmap < ApplicationRecord
  has_many :company_offmaps
  has_many :available_offmaps

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :display_name, as: :displayName
    expose :description
  end
end
