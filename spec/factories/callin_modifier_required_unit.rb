FactoryBot.define do
  factory :callin_modifier_required_unit do
    association :callin_modifier
    association :unit
  end
end
