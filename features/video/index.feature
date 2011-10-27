Feature: list video in stored

  Background:
    Given I have the following videos
      | title                              | format   |
      | Running Central Park in the Fall   | BluRay   |
      | Running Glacier Park in the Spring | Download |
      | Running Balboa Park in the Winter  | DVD      |
      | Cycling Yellowstone in the Summer  | DVD      |
      | Touring Central Park in the Fall   | DVD      |
      | Touring Yellowstone in the Summer  | DVD      |
      | Cycling Yellowstone in the Summer  | DVD      |
      | Touring Central Park in the Fall   | DVD      |
      | Touring Yellowstone in the Summer  | DVD      |
      | Hiking Central Park in the Fall    | DVD      |
      | Hiking Utah in the Spring          | DVD      |
      | Running Glacier Park in the Spring | DVD      |
      | Cycling Utah in the Spring         | DVD      |
      | Touring Utah in the Spring         | DVD      |

#  Scenario: Show a message when there is no video
#    When I am on the "video" page
#    Then I should see "No videos"

  Scenario: list videos in stored
    When I am on the "video" page
    Then I should see "Running Central Park in the Fall"
    Then I should see "Running Glacier Park in the Spring"
    Then I should see "Running Balboa Park in the Winter"

  Scenario: Page links
    When I view all videos from page "1"
    Then I should not see "Cycling Utah in the Spring"
    Then I should not see "Touring Utah in the Spring"
    Then I should see "Previous"
    Then I should see "1"
    Then I should see "2"
    Then I should see "Next"

  Scenario: Next Page links
    When I view all videos from page "2"
    Then I should see "Cycling Utah in the Spring"
    Then I should see "Touring Utah in the Spring"
    Then I should see "Previous"
    Then I should see "1"
    Then I should see "2"
    Then I should see "Next"

  Scenario: Cart is empty    
    When I am on the "video" page
    Then I should see "Your shopping cart is empty"

  Scenario: Cart isn't empty
    And I'm on the view video page of "Running Central Park in the Fall"
    And I choose the "BluRay" format
    And I'm on the view video page of "Running Glacier Park in the Spring"
    And I choose the "Download" format
    And I'm on the view video page of "Running Balboa Park in the Winter"
    And I choose the "DVD" format
    When I am on the "video" page
    Then I should not see "Your shopping cart is empty"
