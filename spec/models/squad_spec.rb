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
require "rails_helper"

RSpec.describe Squad, type: :model do
  let!(:squad) { create :squad}

  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:available_unit) }
    it { should have_many(:squad_upgrades) }
    it { should have_many(:upgrades) }
  end

  describe 'validations' do
    it { should validate_presence_of(:company) }
    it { should validate_presence_of(:vet) }
    it { should validate_presence_of(:tab_category) }
    it { should validate_presence_of(:category_position) }
    it { should validate_numericality_of(:vet) }
    it { should validate_numericality_of(:category_position) }
  end
end
