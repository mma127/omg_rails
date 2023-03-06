# == Schema Information
#
# Table name: transport_allowed_units
#
#  id                                                                      :bigint           not null, primary key
#  internal_description(Internal description of this TransportAllowedUnit) :string
#  created_at                                                              :datetime         not null
#  updated_at                                                              :datetime         not null
#  allowed_unit_id                                                         :bigint           not null
#  transport_id                                                            :bigint           not null
#
# Indexes
#
#  idx_transport_allowed_units_uniq                  (transport_id,allowed_unit_id) UNIQUE
#  index_transport_allowed_units_on_allowed_unit_id  (allowed_unit_id)
#  index_transport_allowed_units_on_transport_id     (transport_id)
#
# Foreign Keys
#
#  fk_rails_...  (allowed_unit_id => units.id)
#  fk_rails_...  (transport_id => units.id)
#
class TransportAllowedUnit < ApplicationRecord
  belongs_to :transport, class_name: "Unit"
  belongs_to :allowed_unit, class_name: "Unit"

  before_save :generate_internal_description

  def self.relationship_map
    result = Hash.new {|h,k| h[k] = [] }
    all.each do |tau|
      result[tau.transport_id] << tau.allowed_unit_id
    end
    result
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :transport_id
    expose :allowed_unit_id
  end

  private

  def generate_internal_description
    self.internal_description = "#{transport.display_name} may transport #{allowed_unit.display_name}"
  end

end
