require 'faker'

FactoryGirl.define do
  factory :role do
    name { Faker::Name.title }

    factory :create_users_role do
      can_create_users true
    end
    factory :update_users_role_role do
      can_update_users_role true

      factory :update_users_role_and_password_role do
        can_update_users_password true
      end
    end
    factory :update_users_password_role do
      can_update_users_password true
    end
    factory :delete_users_role do
      can_delete_users true
    end
    factory :manage_users_role do
      can_create_users true
      can_update_users_password true
      can_update_users_role true
      can_delete_users true
    end
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
