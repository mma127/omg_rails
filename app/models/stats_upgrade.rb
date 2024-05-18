# == Schema Information
#
# Table name: stats_upgrades
#
#  id                                                      :bigint           not null, primary key
#  const_name(SCAR const string, optional)                 :string
#  data                                                    :jsonb            not null
#  display_name                                            :string
#  reference(Attrib reference string, a unique identifier) :string           not null
#  created_at                                              :datetime         not null
#  updated_at                                              :datetime         not null
#  ruleset_id                                              :bigint           not null
#
# Indexes
#
#  index_stats_upgrades_on_ruleset_id                               (ruleset_id)
#  index_stats_upgrades_on_ruleset_id_and_const_name                (ruleset_id,const_name) UNIQUE WHERE (const_name IS NOT NULL)
#  index_stats_upgrades_on_ruleset_id_and_reference_and_const_name  (ruleset_id,reference,const_name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (ruleset_id => rulesets.id)
#
class StatsUpgrade < ApplicationRecord
  belongs_to :ruleset

  validates :reference, presence: true
  validates :const_name, presence: false, uniqueness: { scope: :ruleset_id }
  validates :data, presence: true
end
