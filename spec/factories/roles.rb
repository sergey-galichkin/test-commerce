require 'faker'

FactoryGirl.define do
  factory :role do
    name { Faker::Name.title }
  end

  factory :account_owner, class: Role do
    name 'AccountOwner'
  end
end