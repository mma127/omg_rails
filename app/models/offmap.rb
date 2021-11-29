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
#
class Offmap < ApplicationRecord
  has_many :company_offmaps
end
