FactoryBot.define do
  factory :unit do
    sequence :name do |n| "Unit #{n}" end
    display_name { 'Unit Display Name' }
    const_name { 'Unlock Const Name' }
    transport_squad_slots { 0 }
    transport_model_slots { 0 }
    model_count { 1 }

    type { "Infantry" }
  end
end
