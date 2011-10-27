Feature: Allow user register account

  Scenario: No Input information
    When I am on the "user registration" page
    And I press "Signup"
    Then I should see "First name can't be blank"
    Then I should see "Last name can't be blank"
    Then I should see "Address1 can't be blank"
    Then I should see "Email should look like an email address"
    Then I should see "Password doesn't match confirmation"

  Scenario: input invalid first_name
    When I am on the "user registration" page
    And I fill in "user_email" with "bob@gmail.com"
    And I fill in "user_account_attributes_first_name" with ""
    And I fill in "user_account_attributes_last_name" with "bobs"
    And I fill in "user_account_attributes_address1" with "Califonia, US"
    And I select "United State" from "Country"
    And I select "Alabama" from "State"
    And I fill in "user_account_attributes_city" with "Califonia"
    And I fill in "user_account_attributes_zipcode" with "12345"
    And I fill in "user_password" with "1234567"
    And I fill in "user_password_confirmation" with "1234567"
    And I press "Signup"
    Then I should see "First name can't be blank"

  Scenario: Input invalid last name
    When I am on the "user registration" page
    And I fill in "user_email" with "bob@gmail.com"
    And I fill in "user_account_attributes_first_name" with "john"
    And I fill in "user_account_attributes_last_name" with ""
    And I fill in "user_account_attributes_address1" with "Califonia, US"
    And I select "United State" from "Country"
    And I select "Alabama" from "State"
    And I fill in "user_account_attributes_city" with "Califonia"
    And I fill in "user_account_attributes_zipcode" with "12345"
    And I fill in "user_password" with "1234567"
    And I fill in "user_password_confirmation" with "1234567"
    And I press "Signup"
    Then I should see "Last name can't be blank"

  Scenario: Input invalid address1
    When I am on the "user registration" page
    And I fill in "user_email" with "bob@gmail.com"
    And I fill in "user_account_attributes_first_name" with "john"
    And I fill in "user_account_attributes_last_name" with "bobs"
    And I fill in "user_account_attributes_address1" with ""
    And I select "United State" from "Country"
    And I select "Alabama" from "State"
    And I fill in "user_account_attributes_city" with "Califonia"
    And I fill in "user_account_attributes_zipcode" with "12345"
    And I fill in "user_password" with "1234567"
    And I fill in "user_password_confirmation" with "1234567"
    And I press "Signup"
    Then I should see "Address1 can't be blank"

  Scenario: Input invalid email
    When I am on the "user registration" page
    And I fill in "user_email" with "join"
    And I fill in "user_account_attributes_first_name" with "john"
    And I fill in "user_account_attributes_last_name" with "bobs"
    And I fill in "user_account_attributes_address1" with "Califonia, US"
    And I select "United State" from "Country"
    And I select "Alabama" from "State"
    And I fill in "user_account_attributes_city" with "Califonia"
    And I fill in "user_account_attributes_zipcode" with "12345"
    And I fill in "user_password" with "1234567"
    And I fill in "user_password_confirmation" with "1234567"
    And I press "Signup"
    Then I should see "Email should look like an email address"

  Scenario: Input invalid password
    When I am on the "user registration" page
    And I fill in "user_email" with "bob@gmail.com"
    And I fill in "user_account_attributes_first_name" with "john"
    And I fill in "user_account_attributes_last_name" with "bobs"
    And I fill in "user_account_attributes_address1" with "Califonia, US"
    And I select "United State" from "Country"
    And I select "Alabama" from "State"
    And I fill in "user_account_attributes_city" with "Califonia"
    And I fill in "user_account_attributes_zipcode" with "12345"
    And I fill in "user_password" with "1234567"
    And I fill in "user_password_confirmation" with "1234667"
    And I press "Signup"
    Then I should see "Password doesn't match confirmation"

  Scenario: Input valid information
    When I am on the "user registration" page
    And I fill in "user_email" with "bob@gmail.com"
    And I fill in "user_account_attributes_first_name" with "john"
    And I fill in "user_account_attributes_last_name" with "bobs"
    And I fill in "user_account_attributes_address1" with "Califonia, US"
    And I select "United State" from "Country"
    And I select "Alabama" from "State"
    And I fill in "user_account_attributes_city" with "Califonia"
    And I fill in "user_account_attributes_zipcode" with "12345"
    And I fill in "user_password" with "1234567"
    And I fill in "user_password_confirmation" with "1234567"
    And I press "Signup"
    Then I should see "My Account / Information"
