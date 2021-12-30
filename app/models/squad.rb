# == Schema Information
#
# Table name: squads
#
#  id                                                         :bigint           not null, primary key
#  category_position(Position within the tab the squad is in) :integer
#  name(Squad's custom name)                                  :string
#  tab_category(Tab this squad is in)                         :string
#  vet(Squad's veterancy)                                     :decimal(, )
#  created_at                                                 :datetime         not null
#  updated_at                                                 :datetime         not null
#  available_unit_id                                          :bigint           not null
#  company_id                                                 :bigint
#
# Indexes
#
#  index_squads_on_available_unit_id  (available_unit_id)
#  index_squads_on_company_id         (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Squad < ApplicationRecord
  belongs_to :company
  belongs_to :available_unit
  has_many :squad_upgrades
  has_many :upgrades, through: :squad_upgrades

  enum tab_category: {
    core: 'core',
    assault: 'assault',
    infantry: 'infantry',
    armour: 'armour',
    anti_armour: 'anti_armour',
    support: 'support'
  }

  validates_presence_of :company
  validates_presence_of :vet
  validates_presence_of :tab_category
  validates_presence_of :category_position
  validates_numericality_of :vet
  validates_numericality_of :category_position

  def unit_name
    available_unit.unit.name
  end

  def pop
    available_unit.pop
  end

  def man
    available_unit.man
  end

  def mun
    available_unit.mun
  end

  def fuel
    available_unit.fuel
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :vet
    expose :tab_category, as: :tab
    expose :category_position, as: :index
    expose :company_id, as: :companyId
    expose :unit_id, as: :unitId
    expose :unit_name, as: :unitName
    expose :pop
    expose :man
    expose :mun
    expose :fuel
  end
end
