FactoryBot.define do
  factory :squad_upgrade do
    transient do
      ruleset { create :ruleset }
    end

    squad { association :squad, ruleset: ruleset }
    available_upgrade { association :available_upgrade, ruleset: ruleset }
    is_free { false }
  end
end

