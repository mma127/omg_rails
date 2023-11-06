FactoryBot.define do
  factory :resource_bonus do
    name { "Manpower bonus" }
    resource { "man" }
    man { 100 }
    mun { -30 }
    fuel { -20 }
  end
end
