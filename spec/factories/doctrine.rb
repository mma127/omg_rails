FactoryBot.define do
  factory :doctrine do
    sequence :name do |n| "doctrine #{n}" end
    display_name { "Infantry" }
    sequence :const_name do |n| "doctrine const #{n}" end
    internal_name { "ALLY.DOC.Infantry" }
    association :faction
  end
end


