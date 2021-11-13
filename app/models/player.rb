# == Schema Information
#
# Table name: players
#
#  id                                    :bigint           not null, primary key
#  avatar_url(Player avatar url)         :text
#  last_active_at(Last active timestamp) :datetime
#  name(Player screen name)              :string
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  open_id(Player open id token)         :text
#
class Player < ApplicationRecord

end
