FactoryBot.define do
  factory :company_resource_bonus do
    association :company
    association :resource_bonus
  end
end

