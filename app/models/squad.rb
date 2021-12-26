# == Schema Information
#
# Table name: squads
#
#  id                                                         :bigint           not null, primary key
#  category_position(Position within the tab the squad is in) :integer
#  name(Squad's custom name)                                  :string
#  tab_category(Tab this squad is in)                         :integer
#  vet(Squad's veterancy)                                     :decimal(, )
#  created_at                                                 :datetime         not null
#  updated_at                                                 :datetime         not null
#  company_id                                                 :bigint
#  unit_id                                                    :bigint
#
# Indexes
#
#  index_squads_on_company_id  (company_id)
#  index_squads_on_unit_id     (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (unit_id => units.id)
#
class Squad < ApplicationRecord

  belongs_to :company
  belongs_to :unit
  has_many :squad_upgrades
  has_many :upgrades, through: :squad_upgrades

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :vet
    expose :tab_category, as: :tab
    expose :category_position, as: :position
    expose :company_id, as: :companyId
    expose :unit_id, as: :unitId
  end
end
