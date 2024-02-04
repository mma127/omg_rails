FactoryBot.define do
  factory :company_resource_bonus do
    association :company
    association :resource_bonus
    level { 1 }
  end
end

