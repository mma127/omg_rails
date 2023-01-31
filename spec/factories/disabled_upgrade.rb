FactoryBot.define do
  factory :disabled_upgrade do
    association :restriction
    association :upgrade
    association :ruleset
    priority { 1 }
  end
end


