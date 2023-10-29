FactoryBot.define do
  factory :resource_bonus do
    name { "Manpower bonus" }
    resource { "man" }
    gained { 100 }
    man_lost { 0 }
    mun_lost { 30 }
    fuel_lost { 20 }
  end
end
