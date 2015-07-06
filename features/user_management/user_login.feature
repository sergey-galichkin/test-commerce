Feature: user_management.user_login
User login and password actions

Background:
    Given all accounts are cleaned
    And User registers account
    And user logged out

  Scenario: user visits subdomain home page
    Given registered user opens "/" page
    Then page contains "Login" link
    And page does not contain "LogOff" link
    And page does not contain "Registration" link

  Scenario: user logs in with correct creds
    Given registered user opens "/" page
    When user clicks "Login" link
    And enters correct email and password
    When presses "Log in" button
    Then user is redirected to "/" page
    And page contains "LogOff" link
    And page does not contain "Login" link

   Scenario: user logs in with incorrect login
    Given registered user opens "/" page
    When user clicks "Login" link
    And enters incorrect email and password
    When presses "Log in" button
    Then user is redirected to "/users/sign_in" page

  # Scenario: user logs in with blank login

  # Scenario: user logs in with blank password

  Scenario: user opens change password page
    Given registered user logs in
    When user clicks "Change Password" link
    Then user is redirected to "/users/1/edit" page
    And change password page contains all fields

  Scenario: user changes password
    Given registered user logs in
    When user clicks "Change Password" link
    And user enters new password
    When presses "Update" button
    Then user is redirected to "/users" page

  # Scenario: user changes password/enters blank password

  # Scenario: user changes password/re-enters blank password

  # Scenario: user changes password/re-enters incorrect password

  # Scenario: user opens password reset page

  # Scenario: user receives password reset instuctions

  # Scenario: user logs in ignoring password reset instructions

  # Scenario: user re-sets password

  # Scenario: user enters blank password on password reset page

  # Scenario: user re-enters incorrect password on password reset page

  # Scenario: user re-enters blank password on password reset page

  # Scenario: user receives 2 password reset instuctions and follows link from 1st letter
