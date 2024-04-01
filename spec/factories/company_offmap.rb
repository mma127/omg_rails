FactoryBot.define do
  factory :company_offmap do
    transient do
      ruleset { create :ruleset }
    end

    company { association :company, ruleset: ruleset }
    available_offmap { association :available_offmap, ruleset: ruleset }
  end
end

