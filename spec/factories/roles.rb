require 'faker'

FactoryGirl.define do
  factory :role do
    name { Faker::Name.title }
  end
end