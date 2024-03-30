FactoryBot.define do
  factory :unlock do
    sequence :name do |n| "Unlock #{n}" end
    display_name { 'Unlock Display Name' }
    after :create do |unlock|
      create :restriction, :with_unlock, unlock: unlock
    end
  end
end
