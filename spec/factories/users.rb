require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    role
  end

  factory :account_owner_user, class: User do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    role { create(:account_owner_role) }
  end
end
