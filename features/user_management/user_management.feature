Feature: user_management.manage_users
User CRUD actions

Background:
    Given all accounts are cleaned
    And User registers account

  Scenario: Logged in AccountOwner opens user management page
    Given AccountOwner visits user management page
    Then user management page contains all fields

  # Scenario: Not logged in AccountOwner cannot open user management page
  #   Given AccountOwner logs out
  #   When AccountOwner visits user management page
  #   Then user is redirected to "/home/index" page

  Scenario: AccountOwner opens new user form
    Given AccountOwner visits user management page
    When user clicks "Create New" link
    Then user is redirected to "/users/new" page
    And create new user form contains all fields

  # Scenario: AccountOwner creates new user
  #   Given AccountOwner opens new user page
  #   When AccountOwner properly fills the form
  #   And presses "Create Account" button
  #   Then user is redirected to "/users/index" page


  # Scenario: AccountOwner updates user role

  # Scenario: AccountOwner updates user password

  # Scenario: AccountOwner deletes user

  # Scenario: Logged in AccountOwner cannot delete himself

