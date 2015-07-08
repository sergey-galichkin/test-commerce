Feature: user_management.manage_users
User CRUD actions

Background:
    Given all accounts are cleaned
    And User registers account

  Scenario: User without user management permissions opens user management page
    Given User with "cannot manage users" permission visits user management page
    Then user is redirected to "/" page

  Scenario: User with create users permission opens user management page
    Given User with "create users" permission visits user management page
    Then user management page contains disabled "Create" button

  Scenario: User with delete users permission opens user management page
    Given User with "delete users" permission visits user management page
    Then user management page contains disabled "Delete" link

  Scenario: User with "update users role" permission opens user management page
    Given User with "update users role" permission visits user management page
    Then user management page contains all fields

  Scenario: User with "update users password" permission opens user management page
    Given User with "update users password" permission visits user management page
    Then user management page contains all fields

  Scenario: User with "update users role" permission opens edit user form
    Given User with "update users role" permission visits user management page
    When user clicks "Edit" link
    Then user is redirected to "/users/1/edit" page
    And edit user form contains only role fields

  Scenario: User with "update users password" permission opens edit user form
    Given User with "update users password" permission visits user management page
    When user clicks "Edit" link
    Then user is redirected to "/users/1/edit" page
    And edit user form contains only password fields

  Scenario: AccountOwner opens user management page
    Given AccountOwner visits user management page
    Then user management page contains all fields

  Scenario: AccountOwner opens new user form
    Given AccountOwner visits user management page
    When user clicks "Create New" link
    Then user is redirected to "/users/new" page
    And create new user form contains all fields

  Scenario: AccountOwner creates new user
    Given AccountOwner opens new user page
    When AccountOwner properly fills the form
    And presses "Create User" button
    Then user is redirected to "/users" page
    And user management page shows new user

  Scenario: AccountOwner opens edit user form
    Given AccountOwner visits user management page
    When user clicks "Edit" link
    Then user is redirected to "/users/1/edit" page
    And edit user form contains all fields

  Scenario: AccountOwner updates user role
    Given AccountOwner visits user management page
    And creates new user with role "User"
    And user clicks "Edit" link on created user
    Then user is redirected to "/users/2/edit" page
    And user updates role
    And presses "Update User" button
    Then user is redirected to "/users" page
    And user management page shows updated user role

  Scenario: AccountOwner updates user password
    Given AccountOwner visits user management page
    And creates new user with role "User"
    And user clicks "Edit" link on created user
    Then user is redirected to "/users/2/edit" page
    And user updates password
    And presses "Update User" button
    Then user is redirected to "/users" page

  Scenario: AccountOwner deletes user
    Given AccountOwner visits user management page
    And creates new user with role "User"
    And user clicks "Delete" link on created user
    Then user is redirected to "/users" page
    And user management page does not shows deleted user

  Scenario: Logged in AccountOwner cannot delete himself
    Given AccountOwner visits user management page
    And user clicks "Delete" link
    Then user is redirected to "/users" page
    And user management page shows user

  # Scenario: Not logged in AccountOwner cannot open user management page
  #   Given AccountOwner logs out
  #   When AccountOwner visits user management page
  #   Then user is redirected to "/home/index" page
