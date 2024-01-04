# == Schema Information
#
# Table name: unit_vet
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
#  idx_unit_vet_unit_id_uniq  (unit_id) UNIQUE
#  index_unit_vet_on_unit_id  (unit_id)
#
FactoryBot.define do
  factory :unit_vet do
    association :unit

    vet1_exp { 20 }
    vet1_desc { "vet 1" }
    vet2_exp { 80 }
    vet2_desc { "vet 1" }
    vet3_exp { 120 }
    vet3_desc { "vet 1" }
    vet4_exp { 190 }
    vet4_desc { "vet 1" }
    vet5_exp { 500 }
    vet5_desc { "vet 1" }
  end
end
