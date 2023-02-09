FactoryBot.define do
  factory :ruleset do
    name { 'war' }
    description { 'Starting ruleset' }
    starting_man { 7000 }
    starting_mun { 1600 }
    starting_fuel { 1400 }
    starting_vps { 5 }
  end
end


