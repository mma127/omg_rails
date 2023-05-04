FactoryBot.define do
  factory :available_upgrade_unit do
    association :available_upgrade
    association :unit
  end
end

