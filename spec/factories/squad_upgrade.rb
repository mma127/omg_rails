FactoryBot.define do
  factory :squad_upgrade do
    association :squad
    association :available_upgrade
    is_free { false }
  end
end

