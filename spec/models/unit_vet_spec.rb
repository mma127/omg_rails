# == Schema Information
#
# Table name: unit_vets
#
#  id         :bigint           not null, primary key
#  vet1_desc  :string           not null
#  vet1_exp   :integer          default(0), not null
#  vet2_desc  :string           not null
#  vet2_exp   :integer          default(0), not null
#  vet3_desc  :string           not null
#  vet3_exp   :integer          default(0), not null
#  vet4_desc  :string           not null
#  vet4_exp   :integer          default(0), not null
#  vet5_desc  :string           not null
#  vet5_exp   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  unit_id    :bigint           not null
#
# Indexes
#
#  idx_unit_vet_unit_id_uniq   (unit_id) UNIQUE
#  index_unit_vets_on_unit_id  (unit_id)
#
require "rails_helper"

RSpec.describe UnitVet, type: :model do
  let!(:unit_vet) { create :unit_vet }

  describe 'associations' do
    it { should belong_to(:unit) }
  end
  
  describe "validations" do
    it { should validate_numericality_of(:vet1_exp)}
    it { should validate_numericality_of(:vet2_exp)}
    it { should validate_numericality_of(:vet3_exp)}
    it { should validate_numericality_of(:vet4_exp)}
    it { should validate_numericality_of(:vet5_exp)}
    it { should validate_presence_of(:vet1_desc) }
    it { should validate_presence_of(:vet2_desc) }
    it { should validate_presence_of(:vet3_desc) }
    it { should validate_presence_of(:vet4_desc) }
    it { should validate_presence_of(:vet5_desc) }
  end
end
