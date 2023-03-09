FactoryBot.define do
  factory :available_offmap do
    association :company
    association :offmap

    available { 4 }
    max { 4 }
    mun { 100 }
  end
end
