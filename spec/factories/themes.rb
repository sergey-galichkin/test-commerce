FactoryGirl.define do
  factory :theme do
    name { Faker::Internet.slug }
    zip_file_url { Faker::Internet.url }
    theme_status
  end
end