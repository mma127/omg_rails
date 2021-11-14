# == Schema Information
#
# Table name: unlocks
#
#  id                                                                 :bigint           not null, primary key
#  const_name(Const name of the doctrine ability for the battle file) :string
#  description(Display description of this doctrine ability)          :text
#  image_path(Url to the image to show for this doctrine ability)     :string
#  created_at                                                         :datetime         not null
#  updated_at                                                         :datetime         not null
#
class Unlock < ApplicationRecord
  has_many :doctrine_unlocks
  has_many :doctrines, through: :doctrine_unlocks
end
