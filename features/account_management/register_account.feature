Feature: account_management.register_account
Registering new account
User info, used for registrartion - email(login), password


  Scenario: user opens new account registration form
  	Given user visits start page
  	When user presses "Register" button
  	Then user is redirected to "create new account" page
  	And registration page contains all fields

  Scenario: user registers new account
  	Given user visits registration page
  	When user fills in all fields
  	And presses "Create Account" button
  	Then user is redirected to "account created" page

  Scenario: user enters invalid login
  	Given user visits registration page
  	When user fills in all fields
  	And enters incorrect email
  	And presses "Create Account" button
  	Then user should see "invalid email" message

  Scenario: user enters existing logon
  	Given user visits registration page
  	When user fills in all fields
  	And enters existing email
  	And presses "Create Account" button
  	Then user should see "existing email" message

  Scenario: user enters blank password
  	Given user visits registration page
  	When user fills in all fields
  	And user leaves password field blank
  	Then user should see "Create Account" button is disabled

  Scenario: user re-enters blank password
  	Given user visits registration page
  	When user fills in all fields
  	And user leaves re-enter password field blank
  	Then user should see "Create Account" button is disabled
  	And user should see "passwords do not match" message

  Scenario: user re-enters incorrect password
  	Given user visits registration page
  	When user fills in all fields
  	And user fills re-enter password field with incorrect password
  	Then user should see "Create Account" button is disabled
  	And user should see "passwords do not match" message

  Scenario: user confirms registration
  	Given creates new account
  	And receives confirmation email
  	And follows email confirmation link
  	Then user is redirected to "email confirmed" page


