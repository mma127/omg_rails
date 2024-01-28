FactoryBot.define do
  factory :ruleset do
    name { 'war' }
    ruleset_type { Ruleset.ruleset_types[:war] }
    is_active { true }
    description { 'Starting ruleset' }
    starting_man { 7000 }
    starting_mun { 1600 }
    starting_fuel { 1400 }
    starting_vps { 5 }
    max_vps { 25 }
    max_resource_bonuses { 5 }
  end
end


