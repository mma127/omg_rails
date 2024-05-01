# == Schema Information
#
# Table name: stats_units
#
#  id                                                 :bigint           not null, primary key
#  const_name(SCAR const string, a unique identifier) :string           not null
#  data                                               :jsonb            not null
#  reference(Attrib reference string)                 :string           not null
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  ruleset_id                                         :bigint           not null
#
# Indexes
#
#  index_stats_units_on_ruleset_id                 (ruleset_id)
#  index_stats_units_on_ruleset_id_and_const_name  (ruleset_id,const_name) UNIQUE
#  index_stats_units_on_ruleset_id_and_reference   (ruleset_id,reference)
#
# Foreign Keys
#
#  fk_rails_...  (ruleset_id => rulesets.id)
#
class StatsUnit < ApplicationRecord
  belongs_to :ruleset

  # Since units (sbps) are associated with const_names, we expect const_name to be unique.
  # However, since it's possible that multiple unit const_names link to the same sbps reference, we can't
  # require reference to be unique
  validates :const_name, presence: true, uniqueness: { scope: :ruleset_id }
  validates :reference, presence: true
  validates :data, presence: true

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :const_name, as: :constName
    expose :ruleset_id, as: :rulesetId
    expose :reference
    expose :data
  end
end
