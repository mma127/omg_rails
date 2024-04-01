FactoryBot.define do
  factory :company_offmap do
    transient do
      ruleset { create :ruleset }
    end

    association :company, ruleset: ruleset
    association :available_offmap, ruleset: ruleset
  end
end

