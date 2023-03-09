# == Schema Information
#
# Table name: restriction_offmaps
#
#  id                                                         :bigint           not null, primary key
#  internal_description(What does this RestrictionOffmap do?) :string           not null
#  max(Maximum number purchasable)                            :integer
#  mun(Munitions cost)                                        :integer
#  type(What effect this restriction has on the offmap)       :string           not null
#  created_at                                                 :datetime         not null
#  updated_at                                                 :datetime         not null
#  offmap_id                                                  :bigint
#  restriction_id                                             :bigint
#  ruleset_id                                                 :bigint
#
# Indexes
#
#  index_restriction_offmaps_on_offmap_id       (offmap_id)
#  index_restriction_offmaps_on_restriction_id  (restriction_id)
#  index_restriction_offmaps_on_ruleset_id      (ruleset_id)
#
# Foreign Keys
#
#  fk_rails_...  (offmap_id => offmaps.id)
#  fk_rails_...  (restriction_id => restrictions.id)
#  fk_rails_...  (ruleset_id => rulesets.id)
#
class EnabledOffmap < RestrictionOffmap
  validates :max, numericality: { greater_than_or_equal_to: 0 }
  validates :mun, numericality: { greater_than_or_equal_to: 0 }

  before_save :generate_internal_description

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :internal_description, as: :internalDescription
    expose :max
    expose :mun
    expose :offmap, using: Offmap::Entity
  end

  private

  def generate_internal_description
    self.internal_description = "#{restriction.name} - #{offmap.display_name}"
  end
end
