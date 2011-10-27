Feature: Manage shopping cart
  As a login user
  After I setup shipping address and billing address
  I can see the order confirm page

  Background:
    Given I already logged in successfully
    And I have some addresses in my address books
      | last_name | first_name | address1       | email    |
      | John      | Smith      | 123 ABC Street | a@x.com  |
      | Peter     | Morgan     | 456 DER Street | b@y.com  |
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
    And I already set billing address of cart to "456 DER Street"
    And I already set credit card info as below
      | last_name          | Smith             |
      | first_name         | John              |
      | card_number        | 4242424242424242  |
    When I am on the "confirm order" page

  Scenario: View items in cart
    Then I should see the following item info in card
      | text                                 |
      | Running Central Park in the Fall     |
      | Running Glacier Park in the Spring   |
      | Running Balboa Park in the Winter    |

  Scenario: View shipping info
    Then I should see shipping address
      | text           |
      | John           |
      | Smith          |
      | 123 ABC Street |

  Scenario: View billing info
    Then I should see billing address
      | text          |
      | Peter         |
      | Morgan        |
      | 456 DER Street|

  Scenario: View credit card info
    Then I should see credit card info
      | text              |
      | Smith             |
      | John              |
      | 4242              |

  @javascript
  Scenario: Edit billing address
    When I press "Edit" within "#billing-address-form"
    Then I should be on the "billing address" page

  @javascript
  Scenario: Edit shipping address
    When I press "Edit" within "#shipping-address-form"
    Then I should be on the "shipping address" page

  @javascript
  Scenario: Edit credit card
    When I press "Edit" within "#card-info-form"
    Then I should be on the "billing address" page

  @javascript
  Scenario: Confirm and checkout successfully
    When I press "Confirm and Checkout" within "#checkout"
    And I wait for response about "25" seconds
    And I should be on "the view shopping cart" page
    Then I should see "The checkout process has completed successfully. Thank you for your order."

  @javascript
  Scenario: Confirm and checkout unsuccessfully
    When I am on "the view shopping cart" page
    And I change the quantity of "Running Balboa Park in the Winter" with format "DVD" up to "12345678912345"
    And I press "Save Changes"
    And I am on the "confirm order" page
    And I press "Confirm and Checkout" within "#checkout"
    And I wait for response about "25" seconds
    Then I should see "Please check your balance. The checkout process has been canceled."