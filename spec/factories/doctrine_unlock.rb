FactoryBot.define do
  factory :doctrine_unlock do
    association :doctrine
    association :unlock
    association :ruleset
    tree { 1 }
    branch { 1 }
    row { 1 }
    after :create do |doctrine_unlock|
      create :restriction, :with_doctrine_unlock, doctrine_unlock: doctrine_unlock
    end
  end
end
