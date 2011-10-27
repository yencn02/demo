Feature: Show the newest video

  Background:
    Given I have the following the videos
      | title                              | format   |
      | Running Central Park in the Fall   | BluRay   |
      | Running Glacier Park in the Spring | Download |
      | Running Balboa Park in the Winter  | DVD      |
      | Touring Central Park in the Fall   | DVD      |

  Scenario: list new video
    When I am on the "the home page"
    Then I should see "Running Balboa Park in the Winter"
    Then I should see "Running Glacier Park in the Spring"
    Then I should see "Running Balboa Park in the Winter"
