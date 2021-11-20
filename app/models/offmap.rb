# == Schema Information
#
# Table name: offmaps
#
#  id                                           :bigint           not null, primary key
#  const_name(Offmap const name for battlefile) :string
#  max(Maximum number purchasable)              :integer
#  mun(Munitions cost)                          :integer
#  name(Offmap name)                            :string
#  created_at                                   :datetime         not null
#  updated_at                                   :datetime         not null
#  restriction_id                               :bigint
#
# Indexes
#
#  index_offmaps_on_restriction_id  (restriction_id)
#
# Foreign Keys
#
#  fk_rails_...  (restriction_id => restrictions.id)
#
class Offmap < ApplicationRecord
  belongs_to :restriction
  has_many :company_offmaps
end
