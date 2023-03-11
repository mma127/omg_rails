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
require "rails_helper"

RSpec.describe RestrictionOffmap, type: :model do
  let!(:restriction_offmap) { create :restriction_offmap }

  describe 'associations' do
    it { should belong_to(:restriction) }
    it { should belong_to(:offmap) }
    it { should belong_to(:ruleset) }
  end
end
