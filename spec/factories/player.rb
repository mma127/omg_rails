FactoryBot.define do
  factory :player do
    sequence :name do |n| "Player #{n}" end
    role { "player" }

    trait :admin do
      role { "admin" }
    end
  end
end


