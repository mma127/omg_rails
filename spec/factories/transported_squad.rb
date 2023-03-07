FactoryBot.define do
  factory :transported_squad do
    association :embarked_squad, factory: :squad
    association :transport_squad, factory: :squad
  end
end

