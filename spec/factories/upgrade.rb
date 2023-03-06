FactoryBot.define do
  factory :upgrade do
    sequence :name do |n| "upgrade #{n}" end
    display_name { 'Upgrade Display Name' }
    const_name { 'Upgrade Const Name' }
    is_unit_replace { false }

    type { "Consumable" }
  end
end
