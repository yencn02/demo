Feature: Allow user login
  user fill email and password correct for login admin

  Background:
    Given I already a admin user and a regular user

  Scenario: input invalid email
    When I am on the "login" page
    And I fill in "user_session_email" with "bob@yahoo.com"
    And I fill in "user_session_password" with "test123"
    And I press "Sign In"
    Then I should see "Email is not valid"

  Scenario: input invalid pass word
    When I am on the "login" page
    And I fill in "user_session_email" with "admin@vafitness.com"
    And I fill in "user_session_password" with "test12"
    And I press "Sign In"
    Then I should see "Password is not valid"

  Scenario: input valid email and password of admin user
    When I am on the "login" page
    And I fill in "user_session_email" with "admin@vafitness.com"
    And I fill in "user_session_password" with "test123"
    And I press "Sign In"
    Then I should be on the "user admin" page
