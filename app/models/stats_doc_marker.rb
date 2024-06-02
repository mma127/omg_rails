# == Schema Information
#
# Table name: stats_doc_markers
#
#  id         :bigint           not null, primary key
#  const_name :string           not null
#  faction    :string           not null
#  reference  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ruleset_id :bigint           not null
#
# Indexes
#
#  index_stats_doc_markers_on_ruleset_id                (ruleset_id)
#  index_stats_doc_markers_on_ruleset_id_and_reference  (ruleset_id,reference) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (ruleset_id => rulesets.id)
#
class StatsDocMarker < ApplicationRecord
  belongs_to :ruleset

  validates :reference, presence: true, uniqueness: true
end
