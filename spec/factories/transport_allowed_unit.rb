FactoryBot.define do
  factory :transport_allowed_unit do
    association :transport, factory: :unit
    association :allowed_unit, factory: :unit
  end
end

