FactoryBot.define do
  factory :modified_replace_upgrade do
    association :restriction
    association :upgrade
    association :ruleset
  end
end
