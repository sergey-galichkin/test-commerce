require 'faker'

FactoryGirl.define do
  factory :role do
    name { Faker::Name.title }
  end

  factory :account_owner_role, class: Role do
    name 'AccountOwner'
    can_create_users true
    can_update_users_password true
    can_update_users_role true
    can_delete_users true
  end

  factory :user_role, class: Role do
    name 'User'
  end
end
