Feature: Visiting the TestCommerce start page
Visitor should see start page that contains a link to new account registration page

  Scenario: anonymous user visits TestCommerce Start page
  	Given anonimous user
  	When user opens start page
  	Then user should see link to new account registration page
