# == Schema Information
#
# Table name: squad_upgrades
#
#  id                                                                                        :bigint           not null, primary key
#  is_free(Flag for whether this upgrade is free for the squad and has no availability cost) :boolean
#  created_at                                                                                :datetime         not null
#  updated_at                                                                                :datetime         not null
#  squad_id                                                                                  :bigint
#  upgrade_id                                                                                :bigint
#
# Indexes
#
#  index_squad_upgrades_on_squad_id    (squad_id)
#  index_squad_upgrades_on_upgrade_id  (upgrade_id)
#
# Foreign Keys
#
#  fk_rails_...  (squad_id => squads.id)
#  fk_rails_...  (upgrade_id => upgrades.id)
#
class SquadUpgrade < ApplicationRecord
  belongs_to :squad
  belongs_to :upgrade
end
