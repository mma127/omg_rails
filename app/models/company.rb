# == Schema Information
#
# Table name: companies
#
#  id                                       :bigint           not null, primary key
#  fuel(Fuel available to this company)     :integer          default(0)
#  man(Manpower available to this company)  :integer          default(0)
#  mun(Munitions available to this company) :integer          default(0)
#  name(Company name)                       :string
#  pop(Population cost of this company)     :integer          default(0)
#  vps_earned(VPs earned by this company)   :integer          default(0)
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#  doctrine_id                              :bigint           not null
#  faction_id                               :bigint           not null
#  player_id                                :bigint           not null
#  ruleset_id                               :bigint           not null
#
# Indexes
#
#  index_companies_on_doctrine_id  (doctrine_id)
#  index_companies_on_faction_id   (faction_id)
#  index_companies_on_player_id    (player_id)
#  index_companies_on_ruleset_id   (ruleset_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctrine_id => doctrines.id)
#  fk_rails_...  (faction_id => factions.id)
#  fk_rails_...  (player_id => players.id)
#
class Company < ApplicationRecord
  belongs_to :player
  belongs_to :doctrine
  belongs_to :faction
  belongs_to :ruleset

  has_many :available_units, dependent: :destroy
  has_many :squads, dependent: :destroy
  has_many :company_unlocks, dependent: :destroy
  has_many :unlocks, through: :company_unlocks
  has_many :company_offmaps, dependent: :destroy
  has_many :offmaps, through: :company_offmaps
  has_many :company_resource_bonuses, dependent: :destroy

  validates_presence_of :faction
  validates_presence_of :doctrine
  validates_presence_of :player
  validates_presence_of :ruleset

  def faction_name
    faction.name
  end

  def side
    faction.side
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :player_id, as: :playerId
    expose :doctrine_id, as: :doctrineId
    expose :faction_id, as: :faction_id
    expose :man, :mun, :fuel, :pop
    expose :vps_earned, as: :vpsEarned
    expose :side
    expose :faction_name, as: :factionName

    expose :available_units, as: :availableUnits, using: AvailableUnit::Entity, if: { type: :full }
    expose :squads, using: Squad::Entity, if: { type: :full }
    # TODO Squads, unlocks
  end
end
