FactoryBot.define do
  factory :battle do
    association :ruleset
    sequence :name do |n| "Battle #{n}" end
    size { 1 }

    trait :open do
      state { "open" }
    end

    trait :final do
      state { "final" }
    end

    trait :allied_winner do
      winner { Battle.winners[:allied] }
    end

    trait :axis_winner do
      winner { Battle.winners[:axis] }
    end
  end
end

