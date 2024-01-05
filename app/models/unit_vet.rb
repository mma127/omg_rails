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
class UnitVet < ApplicationRecord
  belongs_to :unit, inverse_of: :unit_vet

  validates_numericality_of :vet1_exp
  validates_numericality_of :vet2_exp
  validates_numericality_of :vet3_exp
  validates_numericality_of :vet4_exp
  validates_numericality_of :vet5_exp

  validates_presence_of :vet1_desc
  validates_presence_of :vet2_desc
  validates_presence_of :vet3_desc
  validates_presence_of :vet4_desc
  validates_presence_of :vet5_desc
end
