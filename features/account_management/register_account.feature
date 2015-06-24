Feature: account_management.register_account
Registering new account
User info, used for registrartion - email(login), password, password re-type, subdomain name, display name


  Scenario: user opens new account registration form
  	Given user visits start page
    When user clicks "Registration" link
    Then user is redirected to "/accounts/new" page
  	And registration page contains all fields

  Scenario: user registers new account
  	Given user visits registration page
  	When user properly fills the form
  	And presses "Create Account" button
  	Then user is redirected to "/accounts/new/login_with_token" page

#  Scenario: user enters blank login
#  	Given user visits registration page
#  	When user properly fills the form
#  	And user leaves email field blank
#  	Then user should see "Create Account" button is disabled

  # Scenario: user enters invalid login
  # 	Given user visits registration page
  # 	When user properly fills the form
  # 	And enters incorrect email
  # 	And presses "Create Account" button
  # 	Then user should see "invalid email" message

  # Scenario: user enters existing login
  # 	Given user visits registration page
  # 	When user properly fills the form
  # 	And enters existing email
  # 	And presses "Create Account" button
  # 	Then user should see "existing email" message

  # Scenario: user enters blank subdomain
  #   Given user visits registration page
  #   When user properly fills the form
  #   And user leaves subdomain field blank
  #   Then user should see "Create Account" button is disabled

  # Scenario: user enters invalid subdomain
  #   Given user visits registration page
  #   When user properly fills the form
  #   And enters incorrect subdomain
  #   And presses "Create Account" button
  #   Then user should see "invalid subdomain" message

  # Scenario: user enters existing subdomain
  #   Given user visits registration page
  #   When user properly fills the form
  #   And enters existing subdomain
  #   And presses "Create Account" button
  #   Then user should see "existing subdomain" message

  # Scenario: user enters blank display name
  #   Given user visits registration page
  #   When user properly fills the form
  #   And user leaves display name field blank
  #   Then user should see "Create Account" button is disabled

  # Scenario: user enters blank password
  # 	Given user visits registration page
  # 	When user properly fills the form
  # 	And user leaves password field blank
  # 	Then user should see "Create Account" button is disabled

  # Scenario: user re-enters blank password
  # 	Given user visits registration page
  # 	When user properly fills the form
  # 	And user leaves re-enter password field blank
  # 	Then user should see "Create Account" button is disabled
  # 	And user should see "passwords do not match" message

  # Scenario: user re-enters incorrect password
  # 	Given user visits registration page
  # 	When user properly fills the form
  # 	And user fills re-enter password field with incorrect password
  # 	Then user should see "Create Account" button is disabled
  # 	And user should see "passwords do not match" message

  # Scenario: user confirms registration
  # 	Given user creates new account
  # 	When user receives confirmation email
  # 	And follows email confirmation link
  # 	Then user is redirected to "email confirmed" page


