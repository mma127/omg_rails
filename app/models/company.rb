# == Schema Information
#
# Table name: companies
#
#  id                                       :bigint           not null, primary key
#  fuel(Fuel available to this company)     :integer
#  man(Manpower available to this company)  :integer
#  mun(Munitions available to this company) :integer
#  name(Company name)                       :string
#  pop(Population cost of this company)     :integer
#  vps_earned(VPs earned by this company)   :integer
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#  doctrine_id                              :bigint
#  faction_id                               :bigint
#  player_id                                :bigint
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
#  fk_rails_...  (player_id => player.id)
#
class Company < ApplicationRecord
  belongs_to :player
  belongs_to :doctrine
  belongs_to :faction

  has_many :company_unlocks
  has_many :unlocks, through: :company_unlocks
  has_many :company_offmaps
  has_many :offmaps, through: :company_offmaps
  has_many :company_resource_bonuses
end
