Feature: Allow user login
  user fill email and password correct for login

  Background:
    Given I already a user


  Scenario: input invalid first name
    When I am on the "login" page
    And I fill in "user_session_email" with "bob@yahoo.com"
    And I fill in "user_session_password" with "test123"
    And I press "Sign In"
    Then I should see "Email is not valid"


  Scenario: input invalid pass word
    When I am on the "login" page
    And I fill in "user_session_email" with "test@vafitness.com"
    And I fill in "user_session_password" with "test12"
    And I press "Sign In"
    Then I should see "Password is not valid"


  Scenario: input valid email and password
    When I am on the "login" page
    And I fill in "user_session_email" with "test@vafitness.com"
    And I fill in "user_session_password" with "test123"
    And I press "Sign In"
    Then I should be on the "user information" page

  
  Scenario: Hide the login box when the current user has logged in
    When I am on "the home page"
    Then I should see element "div.login"
    And I fill in "user_session_email" with "test@vafitness.com"
    And I fill in "user_session_password" with "test123"
    And I press "Login"
    And I should be on the "user information" page
    When I am on "the home page"
    Then I should not see element "div.login"

  Scenario: Users who haven't logged in could not access authentication-required controllers
    When I am on the "admin" page
    Then I should see "You're not authorized to access the page"
    When I am on the "account" page
    Then I should be on the "new session" page
    When I am on the "user information" page
    Then I should be on the "new session" page
    When I am on the "user admin" page
    Then I should see "You're not authorized to access the page"
    When I am on the "shipping address" page
    Then I should be on the "new session" page
    When I am on the "billing address" page
    Then I should be on the "new session" page
    When I am on the "confirm_order_account_path" page
    Then I should be on the "new session" page
    When I am on the "logout" page
    Then I should be on the "new session" page

  @top
  Scenario: Show "Logout" and "My Account" links when a user has already logged in
    When I am on the "login" page
    Then I should not see "LOGOUT" within "#header"
    And I should not see "MY ACCOUNT" within "#header"
    And I fill in "user_session_email" with "test@vafitness.com"
    And I fill in "user_session_password" with "test123"
    And I press "Sign In"
    And I should be on the "user information" page
    Then I should see "LOGOUT" within "#header"
    And I should see "MY ACCOUNT" within "#header"

