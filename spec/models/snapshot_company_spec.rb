# == Schema Information
#
# Table name: companies
#
#  id                                       :bigint           not null, primary key
#  fuel(Fuel available to this company)     :integer          default(0), not null
#  man(Manpower available to this company)  :integer          default(0), not null
#  mun(Munitions available to this company) :integer          default(0), not null
#  name(Company name)                       :string
#  pop(Population cost of this company)     :integer          default(0), not null
#  type(Company type)                       :string           not null
#  uuid(Uuid)                               :string           not null
#  vps_current(VPs available to spend)      :integer          default(0), not null
#  vps_earned(VPs earned by this company)   :integer          default(0), not null
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
#  index_companies_on_uuid         (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (doctrine_id => doctrines.id)
#  fk_rails_...  (faction_id => factions.id)
#  fk_rails_...  (player_id => players.id)
#  fk_rails_...  (ruleset_id => rulesets.id)
#
require "rails_helper"

RSpec.describe SnapshotCompany, type: :model do
  let!(:company) { create :snapshot_company }
end
