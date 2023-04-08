# == Schema Information
#
# Table name: available_offmaps
#
#  id                                                                     :bigint           not null, primary key
#  available(Number of this offmap available to purchase for the company) :integer          default(0), not null
#  max(Max number of this offmap that the company can hold)               :integer          default(0), not null
#  mun(Munitions cost of this offmap)                                     :integer          default(0), not null
#  created_at                                                             :datetime         not null
#  updated_at                                                             :datetime         not null
#  company_id                                                             :bigint
#  offmap_id                                                              :bigint
#
# Indexes
#
#  index_available_offmaps_on_company_id  (company_id)
#  index_available_offmaps_on_offmap_id   (offmap_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (offmap_id => offmaps.id)
#
class BaseAvailableOffmap < AvailableOffmap

end
