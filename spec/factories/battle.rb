FactoryBot.define do
  factory :battle do
    association :ruleset
    sequence :name do |n| "Battle #{n}" end
    size { 1 }
  end
end

