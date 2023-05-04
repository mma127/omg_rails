FactoryBot.define do
  factory :base_available_upgrade do
    pop { 1 }
    man { 0 }
    mun { 50 }
    fuel { 0 }

    association :company
    association :upgrade
  end
end
