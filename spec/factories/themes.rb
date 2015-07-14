FactoryGirl.define do
  factory :theme do
    name { Faker::Internet.slug }
    zip_file_url "#{Faker::Internet.url}.zip"
    status { :processing }
  end
end