# == Schema Information
#
# Table name: squad_upgrades
#
#  id                                                                                        :bigint           not null, primary key
#  is_free(Flag for whether this upgrade is free for the squad and has no availability cost) :boolean
#  created_at                                                                                :datetime         not null
#  updated_at                                                                                :datetime         not null
#  available_upgrade_id                                                                      :bigint
#  squad_id                                                                                  :bigint
#
# Indexes
#
#  index_squad_upgrades_on_available_upgrade_id  (available_upgrade_id)
#  index_squad_upgrades_on_squad_id              (squad_id)
#
# Foreign Keys
#
#  fk_rails_...  (available_upgrade_id => available_upgrades.id)
#  fk_rails_...  (squad_id => squads.id)
#
require "rails_helper"

RSpec.describe SquadUpgrade, type: :model do
  let!(:company) { create :company }
  let!(:available_unit) { create :available_unit, company: company }
  let(:squad) { create :squad, company: company, available_unit: available_unit }
  let(:available_upgrade) { create :available_upgrade, company: company}
  let!(:squad_upgrade) { create :squad_upgrade, squad: squad, available_upgrade: available_upgrade }

  describe 'associations' do
    it { should belong_to(:squad) }
    it { should belong_to(:available_upgrade) }
  end

  describe 'validations' do
    it { should validate_presence_of(:squad) }
    it { should validate_presence_of(:available_upgrade) }
  end
end
