FactoryBot.define do
  factory :upgrade_swap do
    association :unlock
    association :old_upgrade, factory: :upgrade
    association :new_upgrade, factory: :upgrade
  end
end
