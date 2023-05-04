FactoryBot.define do
  factory :modified_add_upgrade do
    association :restriction
    association :upgrade
    association :ruleset
  end
end
