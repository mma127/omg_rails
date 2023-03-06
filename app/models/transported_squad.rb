# == Schema Information
#
# Table name: transported_squads
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  embarked_squad_id  :bigint           not null
#  transport_squad_id :bigint           not null
#
# Indexes
#
#  idx_transported_squads_assoc_uniq               (transport_squad_id,embarked_squad_id) UNIQUE
#  idx_transported_squads_embarked_squad_uniq      (embarked_squad_id) UNIQUE
#  index_transported_squads_on_embarked_squad_id   (embarked_squad_id)
#  index_transported_squads_on_transport_squad_id  (transport_squad_id)
#
# Foreign Keys
#
#  fk_rails_...  (embarked_squad_id => squads.id)
#  fk_rails_...  (transport_squad_id => squads.id)
#
class TransportedSquad < ApplicationRecord
  belongs_to :transport_squad, class_name: "Squad"
  belongs_to :embarked_squad, class_name: "Squad"

  validates :embarked_squad, uniqueness: true
end
