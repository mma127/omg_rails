# == Schema Information
#
# Table name: chats
#
#  id                   :bigint           not null, primary key
#  name(chat room name) :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_chats_on_name  (name) UNIQUE
#
require "rails_helper"

RSpec.describe Chat, type: :model do
  let!(:chat) { create :chat }

  describe 'associations' do
    it { should have_many(:chat_messages) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:name) }
  end
end
