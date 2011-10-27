Feature: Manage shopping cart
  As a login user
  I can add video/video pack to shopping cart
  After that I can view my shopping cart

  Background:
    Given I already logged in successfully
    Given I have the following videos
      | title                                | format   |
      | Running Central Park in the Fall     | BluRay   |
      | Running Glacier Park in the Spring   | Download |
      | Running Balboa Park in the Winter    | DVD      |
    Given I have some items in shopping cart
      | title                                | format   |
      | Running Central Park in the Fall     | BluRay   |
      | Running Glacier Park in the Spring   | Download |
      | Running Balboa Park in the Winter    | DVD      |
    When I am on "the view shopping cart" page

  Scenario: View my shopping cart
    Then I should see "Running Central Park in the Fall"
    And I should see "Running Balboa Park in the Winter"
    And I should see "Running Glacier Park in the Spring"

  Scenario: Edit my shopping cart
    Then I change the quantity of "Running Central Park in the Fall" with format "BluRay" up to "2"
    And I change the quantity of "Running Balboa Park in the Winter" with format "DVD" up to "3"
    And I change the quantity of "Running Glacier Park in the Spring" with format "Download" up to "4"
    And I press "Save Changes"
    And I am on "the view shopping cart" page
    And I should see the new value of subtotal

  Scenario: Delete an item in shopping cart
    Then I delete item of "Running Central Park in the Fall" with format "BluRay" out of shopping cart
    And I should not see "Running Central Park in the Fall"
    And I delete item of "Running Balboa Park in the Winter" with format "DVD" out of shopping cart
    And I should not see "Running Balboa Park in the Winter"

  @javascript
  Scenario: Process to checkout
    When I press "Proceed to Checkout"
    Then I should be on the "shipping address" page

#  Scenario: Save for later
#    Then I set status of "Running Central Park in the Fall" with format "BluRay" to be "Save for later"
#    And I am on "the view shopping cart" page
#    And I should not see "Running Central Park in the Fall"