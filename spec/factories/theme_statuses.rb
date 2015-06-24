FactoryGirl.define do
  factory :theme_status do
    name { Faker::Lorem.characters(20) }
  end
end
