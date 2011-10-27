Feature: Show the platform listing feature
  should show the platform listing feature

  Background:
    Given I have the following the categories
      | name    | categorizable |
      | Running | true          |
      | Hiking  | true          |
      | Cycling |               |
      | Touring |               |

  Scenario: list category exist categorizables
    When I am on the "the home page"
    Then I should see "Running"
    Then I should see "Hiking"

  Scenario: don't list category not exists categorizables
    When I am on the "the home page"
    Then I should not see "Cycling"
    Then I should not see "Touring"
