FactoryBot.define do
  factory :doctrine_unlock do
    association :doctrine
    association :unlock
    association :ruleset
    association :restriction
    tree { 1 }
    branch { 1 }
    row { 1 }
  end
end
