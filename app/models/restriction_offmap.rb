# == Schema Information
#
# Table name: restriction_offmaps
#
#  id                              :bigint           not null, primary key
#  max(Maximum number purchasable) :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  offmap_id                       :bigint
#  restriction_id                  :bigint
#
# Indexes
#
#  index_restriction_offmaps_on_offmap_id       (offmap_id)
#  index_restriction_offmaps_on_restriction_id  (restriction_id)
#
# Foreign Keys
#
#  fk_rails_...  (offmap_id => offmaps.id)
#  fk_rails_...  (restriction_id => restrictions.id)
#
class RestrictionOffmap < ApplicationRecord
  belongs_to :restriction
  belongs_to :offmap
end

