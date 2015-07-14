class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.try :role

    can :read, User if user.role.can_create_users? || user.role.can_update_users_password? || user.role.can_update_users_role? || user.role.can_delete_users
    can :create, User if user.role.can_create_users?
    can :update, User if user.role.can_update_users_password? || user.role.can_update_users_role?
    can :destroy, User if user.role.can_delete_users?
    can :update_users_role, User if user.role.can_update_users_role?
    can :update_users_password, User if user.role.can_update_users_password?
    can :read, Theme if user.role.can_create_themes? || user.role.can_delete_themes?
    can :create, Theme if user.role.can_create_themes?
    can :create_completed, Theme if user.role.can_create_themes?
    can :destroy, Theme if user.role.can_delete_themes?
  end
end