FactoryBot.define do
  factory :unit do
    sequence :name do |n| "Unit #{n}" end
    display_name { 'Unit Display Name' }
    const_name { 'Unlock Const Name' }

    type { "Infantry" }
  end
end
