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

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :unit_id, as: :unitId
    expose :vet1_exp, as: :vet1Exp
    expose :vet1_desc, as: :vet1Desc
    expose :vet2_exp, as: :vet2Exp
    expose :vet2_desc, as: :vet2Desc
    expose :vet3_exp, as: :vet3Exp
    expose :vet3_desc, as: :vet3Desc
    expose :vet4_exp, as: :vet4Exp
    expose :vet4_desc, as: :vet4Desc
    expose :vet5_exp, as: :vet5Exp
    expose :vet5_desc, as: :vet5Desc
  end
end
