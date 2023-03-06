FactoryBot.define do
  factory :squad do
    vet { 0 }
    tab_category { "core" }
    category_position { 0 }
    sequence :uuid do |n| "uuid #{n}" end

    association :company
    association :available_unit
  end
end

