Feature: Allow user login
  only user admin can access admin page

  Background:
    Given I already a admin user and a regular user

  Scenario: admin user
    When I am on the "login" page
    And I fill in "user_session_email" with "admin@vafitness.com"
    And I fill in "user_session_password" with "test123"
    And I press "Sign In"
    Then I should be on the "user admin" page
    When I am on the "video admin" page
    Then I should be on the "video admin" page
    When I am on the "video formats admin" page
    Then I should be on the "video formats admin" page
    When I am on the "video pack formats admin" page
    Then I should be on the "video pack formats admin" page
    When I am on the "gym locations admin" page
    Then I should be on the "gym locations admin" page
    When I am on the "promos admin" page
    Then I should be on the "promos admin" page
    When I am on the "orders admin" page
    Then I should be on the "orders admin" page

  Scenario: regular user
    When I am on the "login" page
    And I fill in "user_session_email" with "test@vafitness.com"
    And I fill in "user_session_password" with "test123"
    And I press "Sign In"
    Then I should be on the "user information" page
    When I am on the "user admin" page
    Then I should see "You're not authorized to access the page"
    When I am on the "video admin" page
    Then I should see "You're not authorized to access the page"
    When I am on the "video formats admin" page
    Then I should see "You're not authorized to access the page"
    When I am on the "video pack formats admin" page
    Then I should see "You're not authorized to access the page"
    When I am on the "gym locations admin" page
    Then I should see "You're not authorized to access the page"
    When I am on the "promos admin" page
    Then I should see "You're not authorized to access the page"
    When I am on the "orders admin" page
    Then I should see "You're not authorized to access the page"

  Scenario: don't member
    When I am on the "admin" page
    Then I should see "You're not authorized to access the page"
    


