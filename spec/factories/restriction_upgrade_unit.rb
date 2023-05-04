FactoryBot.define do
  factory :restriction_upgrade_unit do
    association :restriction_upgrade
    association :unit
  end
end

