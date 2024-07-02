# == Schema Information
#
# Table name: available_offmaps
#
#  id                                                                     :bigint           not null, primary key
#  available(Number of this offmap available to purchase for the company) :integer          default(0), not null
#  max(Max number of this offmap that the company can hold)               :integer          default(0), not null
#  mun(Munitions cost of this offmap)                                     :integer          default(0), not null
#  created_at                                                             :datetime         not null
#  updated_at                                                             :datetime         not null
#  company_id                                                             :bigint
#  offmap_id                                                              :bigint
#
# Indexes
#
#  index_available_offmaps_on_company_id  (company_id)
#  index_available_offmaps_on_offmap_id   (offmap_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (offmap_id => offmaps.id)
#
class AvailableOffmap < ApplicationRecord
  belongs_to :company
  belongs_to :offmap
  has_many :company_offmaps, dependent: :destroy

  scope :offmap_active, -> { joins(:offmap).where(offmaps: { disabled: false }) }

  validates :max, numericality: { greater_than_or_equal_to: 0 }
  validates :available, numericality: { greater_than_or_equal_to: 0 }

  def offmap_name
    offmap.name
  end

  def offmap_display_name
    offmap.display_name
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :company_id, as: :companyId
    expose :offmap_id, as: :offmapId
    expose :offmap_name, as: :offmapName
    expose :offmap_display_name, as: :offmapDisplayName
    expose :available
    expose :max
    expose :mun

    expose :offmap, using: Offmap::Entity, if: { type: :include_unit }
  end
end
