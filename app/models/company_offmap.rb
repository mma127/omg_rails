# == Schema Information
#
# Table name: company_offmaps
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  available_offmap_id :bigint
#  company_id          :bigint
#
# Indexes
#
#  index_company_offmaps_on_available_offmap_id  (available_offmap_id)
#  index_company_offmaps_on_company_id           (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (available_offmap_id => available_offmaps.id)
#  fk_rails_...  (company_id => companies.id)
#
class CompanyOffmap < ApplicationRecord
  belongs_to :company
  belongs_to :available_offmap
  has_one :offmap, through: :available_offmap

  def mun
    available_offmap.mun
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :company_id, as: :companyId
    expose :available_offmap_id, as: :availableOffmapId
    expose :mun
    expose :offmap, using: Offmap::Entity, if: { type: :include_offmap }
  end
end
