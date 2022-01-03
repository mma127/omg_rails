FactoryBot.define do
  factory :infantry do
    sequence :name do |n| "Infantry #{n}" end
    display_name { 'Infantry Display Name' }
    const_name { 'Infantry Const Name' }
    type { "Infantry" }
  end
end
