FactoryBot.define do
  factory :restriction do
    name { "faction level" }
    description { "for a faction" }
    association :faction
  end
end



