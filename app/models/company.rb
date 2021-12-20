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
#
# Indexes
#
#  index_companies_on_doctrine_id  (doctrine_id)
#  index_companies_on_faction_id   (faction_id)
#  index_companies_on_player_id    (player_id)
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

  has_many :available_units
  has_many :company_unlocks
  has_many :unlocks, through: :company_unlocks
  has_many :company_offmaps
  has_many :offmaps, through: :company_offmaps
  has_many :company_resource_bonuses

  validates_presence_of :faction
  validates_presence_of :doctrine
  validates_presence_of :player

  def side
    faction.side
  end
end
