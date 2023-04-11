FactoryBot.define do
  factory :callin_modifier do
    modifier { 0.5 }
    priority { 1 }
    modifier_type { "multiplicative" }
    description { "callin modifier description" }
  end
end
