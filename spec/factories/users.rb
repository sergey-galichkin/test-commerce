require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    association :role
  end
end