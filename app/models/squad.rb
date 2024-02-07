# == Schema Information
#
# Table name: squads
#
#  id                                                                :bigint           not null, primary key
#  category_position(Position within the tab the squad is in)        :integer          not null
#  name(Squad's custom name)                                         :string
#  pop(Total pop of the squad including unit and all upgrades)       :decimal(, )
#  tab_category(Tab this squad is in)                                :string           not null
#  total_model_count(Total model count of the unit and all upgrades) :integer
#  uuid(Unique uuid)                                                 :string           not null
#  vet(Squad's veterancy)                                            :decimal(, )
#  created_at                                                        :datetime         not null
#  updated_at                                                        :datetime         not null
#  available_unit_id                                                 :bigint
#  company_id                                                        :bigint
#
# Indexes
#
#  index_squads_on_available_unit_id  (available_unit_id)
#  index_squads_on_company_id         (company_id)
#  index_squads_on_uuid               (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (available_unit_id => available_units.id)
#  fk_rails_...  (company_id => companies.id)
#
class Squad < ApplicationRecord
  belongs_to :company
  belongs_to :available_unit

  has_many :squad_upgrades, :inverse_of => :squad, dependent: :destroy
  has_many :available_upgrades, through: :squad_upgrades

  # The TransportSquad associations for which this Squad is the transport
  has_many :transporting_transported_squads, foreign_key: "transport_squad_id", class_name: "TransportedSquad", dependent: :destroy
  # The Squads for which this Squad is the transport
  has_many :squads_in_transport, through: :transporting_transported_squads, source: :embarked_squad, class_name: "Squad"
  # The TransportSquad associations for which this Squad is the embarked passenger
  has_one :embarked_transported_squad, foreign_key: "embarked_squad_id", class_name: "TransportedSquad", dependent: :destroy
  # The Squad for which this Squad is the embarked passenger
  has_one :embarked_transport, through: :embarked_transported_squad, source: :transport_squad, class_name: "Squad"

  delegate :unit, to: :available_unit

  enum tab_category: {
    core: 'core',
    assault: 'assault',
    infantry: 'infantry',
    armour: 'armour',
    anti_armour: 'anti_armour',
    support: 'support',
    holding: "holding"
  }

  validates_presence_of :company
  validates_presence_of :vet
  validates_presence_of :tab_category
  validates_presence_of :category_position
  validates_numericality_of :vet
  validates_numericality_of :category_position

  def unit_id
    unit.id
  end

  def unit_name
    unit.name
  end

  def unit_display_name
    unit.display_name
  end

  def unit_type
    unit.type
  end

  def unit_pop
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

  def transported_squad_uuids
    vals = squads_in_transport.pluck(:uuid)
    vals.empty? ? nil : vals
  end

  def used_squad_slots
    squads_in_transport.count
  end

  def used_model_slots
    squads_in_transport.pluck(:total_model_count).sum { |count| count || 1 } # default to model count 1 if for some reason the total model count is nil
  end

  def transport_squad_slots
    unit.transport_squad_slots
  end

  def transport_model_slots
    unit.transport_model_slots
  end

  def transport_uuid
    embarked_transport&.uuid
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :uuid
    expose :name
    expose :vet
    expose :tab_category, as: :tab
    expose :category_position, as: :index
    expose :company_id, as: :companyId
    expose :unit_id, as: :unitId
    expose :available_unit_id, as: :availableUnitId
    expose :unit_name, as: :unitName
    expose :unit_display_name, as: :unitDisplayName
    expose :unit_type, as: :unitType
    expose :unit_pop, as: :unitPop
    expose :pop
    expose :man
    expose :mun
    expose :fuel

    # Transport related
    expose :total_model_count, as: :totalModelCount
    expose :used_squad_slots, as: :usedSquadSlots
    expose :used_model_slots, as: :usedModelSlots
    expose :transport_squad_slots ,as: :transportSquadSlots
    expose :transport_model_slots, as: :transportModelSlots
    expose :transport_uuid, as: :transportUuid
    expose :transported_squad_uuids, as: :transportedSquadUuids
  end

  def company_name
    company.name
  end

  def player_name
    company.player.name
  end

  def player_id
    company.player_id
  end

  def faction_name
    company.faction_name
  end

  def faction_id
    company.faction_id
  end

  def faction_display_name
    company.faction.display_name
  end

  def doctrine_name
    company.doctrine_name
  end

  def doctrine_id
    company.doctrine_id
  end

  def doctrine_display_name
    company.doctrine_display_name
  end

  def side
    company.side
  end

  def unit_vet
    unit.unit_vet
  end

  class TopExpSquadEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName
    expose :side

    expose :vet, as: :exp
    expose :unit_name, as: :unitName
    expose :unit_display_name, as: :unitDisplayName
    expose :unit_vet, as: :vet, using: UnitVet::Entity
  end
end
