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
class SquadUpgrade < ApplicationRecord
  belongs_to :squad
  belongs_to :available_upgrade
end
