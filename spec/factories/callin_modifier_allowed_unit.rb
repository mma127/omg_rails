FactoryBot.define do
  factory :callin_modifier_allowed_unit do
    association :callin_modifier
    association :unit
  end
end