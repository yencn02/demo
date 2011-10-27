Feature: Allow user set shipping address
  As a login user
  When I press Process to checkout
  I must setup values of shipping address

  Background:
    Given I already logged in successfully
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
    And I have some addresses in my address books
      | last_name | first_name | address1       | email    |
      | John      | Smith      | 123 ABC Street | a@x.com  |
      | Peter     | Morgan     | 456 DER Street | b@y.com  |
    And I am on "the view shopping cart" page
    When I press "Proceed to Checkout"
    Then I should be on the "shipping address" page

  @javascript
  Scenario: Ship to a new address successfully
    When I fill in "First Name" with "Cathy"
    And I fill in "Last Name" with "Nguyen"
    And I fill in "Street Address 1" with "34/324 Smooth Street"
    And I fill in "Street Address 2" with "34/324"
    And I fill in "City" with "Alaska"
    And I select "New York" from "State"
    And I fill in "Zip" with "12345"
    And I select "United State" from "Country"
    And I press "Ship to this Address" within "#new_address_book"
    And I wait for response about "2" seconds
    Then I should be on the "billing address" page

  @javascript
  Scenario: Ship to a new address unsuccessfully with blank values
    When I press "Ship to this Address" within "#new_address_book"
    And I wait for response
    Then I should see below
      |text                       |
      |First name can't be blank  |
      |Last name can't be blank   |
      |Address1 can't be blank    |
      |City can't be blank        |
      |Zipcode can't be blank     |

  @javascript
  Scenario: Ship to a new address unsuccessfully with invalid zipcode
    When I fill in "First Name" with "Cathy"
    And I fill in "Last Name" with "Nguyen"
    And I fill in "Street Address 1" with "123 ABC Street"
    And I fill in "City" with "Alaska"
    And I select "New York" from "State"
    And I fill in "Zip" with "123456123"
    And I select "United State" from "Country"
    And I press "Ship to this Address" within "#new_address_book"
    And I wait for response about "5" seconds
    Then I should see "Zipcode is invalid"

  @javascript
  Scenario: Delete an address
    When I delete address "123 ABC Street"
    And I wait for response about "2" seconds
    And I should not see "123 ABC Street"

  @javascript
  Scenario: View my address books
    Then I should see my address books
      | last_name | first_name | address1       | email    |
      | John      | Smith      | 123 ABC Street | a@x.com  |
      | Peter     | Morgan     | 456 DER Street | b@y.com  |

  @javascript
  Scenario: Ship to an existing address
    When I select shipping to address of "123 ABC Street"
    Then I should be on the "billing address" page

  @javascript
  Scenario: Edit an address
    When I edit address of "123 ABC Street"
    And I fill in "First Name" with "Test Edit"
    And I fill in "Street Address 1" with "123 XXX street"
    And I fill in "Street Address 2" with "456 YYY street"
    And I fill in "City" with "San Diego"
    When I press "Ship to this Address" within "#new_address_book"
    And I wait for response about "2" seconds
    Then I should be on the "billing address" page
    When I am on the "shipping address" page
    Then I should see below
      |text           |
      |Test Edit      |
      |123 XXX street |
      |456 YYY street |
      |San Diego      |