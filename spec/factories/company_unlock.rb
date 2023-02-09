FactoryBot.define do
  factory :company_unlock do
    association :company
    association :doctrine_unlock
  end
end
