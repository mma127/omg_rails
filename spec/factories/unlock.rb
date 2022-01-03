FactoryBot.define do
  factory :unlock do
    sequence :name do |n| "Unlock #{n}" end
    display_name { 'Unlock Display Name' }
  end
end
