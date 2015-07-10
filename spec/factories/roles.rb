require 'faker'

FactoryGirl.define do
  factory :role do
    name { Faker::Name.title }

    factory :create_users_role do
      name 'create users'
      can_create_users true
    end
    factory :update_users_role_role do
      name 'update users role'
      can_update_users_role true

      factory :update_users_role_and_password_role do
        name 'update users role and password'
        can_update_users_password true
      end
    end
    factory :update_users_password_role do
      name 'update users password'
      can_update_users_password true
    end
    factory :delete_users_role do
      name 'delete users password'
      can_delete_users true
    end
    factory :manage_users_role do
      can_create_users true
      can_update_users_password true
      can_update_users_role true
      can_delete_users true
    end
  end

  factory :account_owner_role, parent: :manage_users_role do
    name 'AccountOwner'
  end
  factory :user_role, parent: :role do
    name 'User'
  end

end
