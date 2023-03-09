# == Schema Information
#
# Table name: offmaps
#
#  id                                           :bigint           not null, primary key
#  const_name(Offmap const name for battlefile) :string
#  description(Offmap description)              :string
#  display_name(Offmap display name)            :string
#  name(Offmap name)                            :string
#  created_at                                   :datetime         not null
#  updated_at                                   :datetime         not null
#
require "rails_helper"

RSpec.describe Offmap, type: :model do
  let!(:offmap) { create :offmap }

  describe 'associations' do
    it { should have_many(:company_offmaps) }
    it { should have_many(:available_offmaps) }
  end
end
