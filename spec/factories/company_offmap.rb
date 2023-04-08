FactoryBot.define do
  factory :company_offmap do
    association :company
    association :available_offmap
  end
end

