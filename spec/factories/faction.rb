FactoryBot.define do
  factory :faction do
    sequence :name do |n| "faction #{n}" end
    display_name { "Americans" }
    sequence :const_name do |n| "faction const #{n}" end
    internal_name { "Factions.Allies" }
    side { 'allied' }

    trait :axis do
      side { 'axis' }
    end
  end
end

