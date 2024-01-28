FactoryBot.define do
  factory :company_unlock do
    transient do
      ruleset { create :ruleset }
    end

    company { association :company, ruleset: ruleset }
    doctrine_unlock { association :doctrine_unlock, ruleset: ruleset }
  end
end
