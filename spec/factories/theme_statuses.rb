FactoryGirl.define do
  factory :theme_status do
    name { Faker::Lorem.characters(20) }
  end

  factory :processing_theme_status, class: ThemeStatus do
    name { :Processing }
  end
end
