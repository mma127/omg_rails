# == Schema Information
#
# Table name: company_unlocks
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id         :bigint
#  doctrine_unlock_id :bigint
#
# Indexes
#
#  index_company_unlocks_on_company_id          (company_id)
#  index_company_unlocks_on_doctrine_unlock_id  (doctrine_unlock_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (doctrine_unlock_id => doctrine_unlocks.id)
#
class CompanyUnlock < ApplicationRecord
  belongs_to :company
  belongs_to :doctrine_unlock

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :company_id, as: :companyId
    expose :doctrine_unlock_id, as: :doctrineUnlockId
    expose :doctrine_unlock, using: DoctrineUnlock::Entity, if: { type: :include_unlock }
  end
end
