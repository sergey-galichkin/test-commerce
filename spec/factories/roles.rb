require 'faker'

FactoryGirl.define do
  factory :role do |f|
    f.name { Faker::Name.title }
  end
end