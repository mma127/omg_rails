FactoryBot.define do
  factory :restriction do
    name { "faction level" }
    description { "for a faction" }
    association :faction
  end

  trait :with_doctrine do
    faction { nil }
    association :doctrine
  end

  trait :with_doctrine_unlock do
    faction { nil }
    association :doctrine_unlock
  end

  trait :with_unlock do
    faction { nil }
    association :unlock
  end
end



