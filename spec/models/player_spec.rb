# == Schema Information
#
# Table name: players
#
#  id                          :bigint           not null, primary key
#  avatar(Player avatar url)   :text
#  current_sign_in_at          :datetime
#  current_sign_in_ip          :string
#  last_sign_in_at             :datetime
#  last_sign_in_ip             :string
#  name(Player screen name)    :string
#  provider(Omniauth provider) :string
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  uid(Omniauth uid)           :string
#  vps(WAR VPs earned)         :integer          default(0), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
require "rails_helper"

RSpec.describe Player, type: :model do
  let!(:player) { create :player}

  describe 'associations' do
    it { should have_many(:companies) }
    it { should have_many(:factions) }
    it { should have_many(:doctrines) }
  end
end


