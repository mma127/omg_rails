# == Schema Information
#
# Table name: stats_weapons
#
#  id                                                      :bigint           not null, primary key
#  data                                                    :jsonb            not null
#  reference(Attrib reference string, a unique identifier) :string           not null
#  created_at                                              :datetime         not null
#  updated_at                                              :datetime         not null
#  ruleset_id                                              :bigint           not null
#
# Indexes
#
#  index_stats_weapons_on_ruleset_id                (ruleset_id)
#  index_stats_weapons_on_ruleset_id_and_reference  (ruleset_id,reference) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (ruleset_id => rulesets.id)
#
class StatsWeapon < ApplicationRecord
  belongs_to :ruleset

  validates :reference, presence: true, uniqueness: true
  validates :data, presence: true
end
