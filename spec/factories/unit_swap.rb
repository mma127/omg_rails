FactoryBot.define do
  factory :unit_swap do
    association :unlock
    association :old_unit, factory: :unit
    association :new_unit, factory: :unit
  end
end
