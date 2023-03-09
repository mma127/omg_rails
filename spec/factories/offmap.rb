FactoryBot.define do
  factory :offmap do
    sequence :name do |n| "Offmap #{n}" end
    display_name { 'Offmap Display Name' }
    const_name { 'Offmap Const Name' }
    description { 'Offmap description'}
  end
end