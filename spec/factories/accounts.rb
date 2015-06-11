require 'faker'

FactoryGirl.define do
  factory :account do |f|
    f.name { Faker::Company.name }
    f.subdomain { Faker::Internet.domain_word }
  end
end