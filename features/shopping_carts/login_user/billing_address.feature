Feature: Allow user setup billing address
  As a login user
  After I setup shipping address
  I must continue to setup values of billing address
  Background:
    Given I already logged in successfully
    And I have some addresses in my address books
      | last_name | first_name | address1       | email    |
      | John      | Smith      | 123 ABC Street | a@x.com  |
      | Peter     | Morgan     | 456 DER Street | b@y.com  |
    And I have the following card types
      | name         | code     |
      | Discover     | discover |
      | Visa         | visa     |
    And I have the following videos
      | title                                | format   |
      | Running Central Park in the Fall     | BluRay   |
      | Running Glacier Park in the Spring   | Download |
      | Running Balboa Park in the Winter    | DVD      |
    And I have some items in shopping cart
      | title                                | format   |
      | Running Central Park in the Fall     | BluRay   |
      | Running Glacier Park in the Spring   | Download |
      | Running Balboa Park in the Winter    | DVD      |
    And I already set shipping address of cart to "123 ABC Street"
    And I am on the "billing address" page

  @javascript
  Scenario: Setup credit cart info and billing address reuse shipping address
    When I select "Visa" from "Type of card"
    And I fill in "credit_card_first_name" with "John"
    And I fill in "credit_card_last_name" with "Smith"
    And I fill in "Card number" with "4242424242424242"
    And I select "April" from "date_expiration_month"
    And I select a year from "date_expiration_year"
    And I check "use_shipping_address"
    And I wait for response
    And I press "Review Order" within "#new_address_book"    
    And I wait for response
    Then I should be on the "confirm order" page

  @javascript
  Scenario: Setup credit cart info and a new billing address
    When I select "Visa" from "Type of card"
    And I fill in "credit_card_first_name" with "John"
    And I fill in "credit_card_last_name" with "Smith"
    And I fill in "Card number" with "4242424242424242"
    And I select "April" from "date_expiration_month"
    And I select a year from "date_expiration_year"    
    And I fill in "Street Address 1" with "123 ABC street"
    And I fill in "Street Address 2" with "456 DEF street"
    And I fill in "City" with "Alaska"
    And I select "New York" from "State"
    And I fill in "Zip" with "12345"
    And I select "United State" from "Country"    
    And I press "Review Order" within "#new_address_book"
    And I wait for response about "5" seconds
    Then I should be on the "confirm order" page

  @javascript
  Scenario: Setup invalid credit cart info
    When I press "Review Order" within "#new_address_book"
    And I wait for response about "2" seconds
    Then I should see below
      |text                                     |
      |Number is not a valid credit card number |
      |Year expired                             |
      |Last name cannot be empty                |
      |First name cannot be empty               |

  @javascript
  Scenario: Setup invalid billing address
    Then I select "Visa" from "Type of card"
    And I fill in "credit_card_first_name" with "John"
    And I fill in "credit_card_last_name" with "Smith"
    And I fill in "Card number" with "4242424242424242"
    And I select "April" from "date_expiration_month"
    And I select a year from "date_expiration_year"
    And I press "Review Order" within "#new_address_book"
    And I wait for response about "5" seconds
    Then I should see below
      |text                    |
      |Address1 can't be blank |
      |City can't be blank     |
      |Zipcode can't be blank  |

  @javascript
  Scenario: Load selected credit card and billing address
    Given I already set billing address of cart to "456 DER Street"
    And I already set credit card info as below
      | last_name          | Smith             |
      | first_name         | John              |
      | card_number        | 4242424242424242  |
    Then I am on the "billing address" page
    And the field "credit_card_first_name" should contain "John"
    And the field "credit_card_last_name" should contain "Smith"
    And the field "credit_card_card_number" should contain "4242424242424242"
    And the field "Street Address 1" should contain "456 DER Street"