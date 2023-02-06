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
#
# Foreign Keys
#
#  fk_rails_...  (doctrine_id => doctrines.id)
#  fk_rails_...  (faction_id => factions.id)
#  fk_rails_...  (player_id => players.id)
#  fk_rails_...  (ruleset_id => rulesets.id)
#
require "rails_helper"

RSpec.describe Company, type: :model do
  let!(:company) { create :company}

  describe 'associations' do
    it { should belong_to(:player) }
    it { should belong_to(:doctrine) }
    it { should belong_to(:faction) }
    it { should belong_to(:ruleset) }

    it { should have_many(:available_units) }
    it { should have_many(:squads) }
    it { should have_many(:company_unlocks) }
    it { should have_many(:doctrine_unlocks) }
    it { should have_many(:company_offmaps) }
    it { should have_many(:offmaps) }
    it { should have_many(:company_resource_bonuses) }
  end

  describe 'validations' do
    it { should validate_presence_of(:faction) }
    it { should validate_presence_of(:doctrine) }
    it { should validate_presence_of(:player) }
    it { should validate_presence_of(:ruleset) }
  end
end

