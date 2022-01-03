FactoryBot.define do
  factory :squad do
    vet { 0 }
    tab_category { "core" }
    category_position { 0 }

    association :company
    association :available_unit
  end
end

