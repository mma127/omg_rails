FactoryBot.define do
  factory :unit_vet do
    association :unit

    vet1_exp { 20 }
    vet1_desc { "vet 1" }
    vet2_exp { 80 }
    vet2_desc { "vet 1" }
    vet3_exp { 120 }
    vet3_desc { "vet 1" }
    vet4_exp { 190 }
    vet4_desc { "vet 1" }
    vet5_exp { 500 }
    vet5_desc { "vet 1" }
  end
end
