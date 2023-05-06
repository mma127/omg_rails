FactoryBot.define do
  factory :available_upgrade do
    pop { 5 }
    man { 200 }
    mun { 50 }
    fuel { 40 }
    type { "BaseAvailableUpgrade" }

    association :company
    association :upgrade
    association :unit
  end
end
