require 'faker'

FactoryGirl.define do
  factory :account do
    name { Faker::Company.name }
    subdomain { Faker::Internet.domain_word }
    registration_token { SecureRandom.uuid }
  end
end