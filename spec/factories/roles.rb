require 'faker'

FactoryGirl.define do
  factory :role do
    name { Faker::Name.title }
  end

  factory :account_owner_role, class: Role do
    name 'AccountOwner'
  end

  factory :user_role, class: Role do
    name 'User'
  end
end
