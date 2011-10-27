Feature: show a video

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

  @javascript
  Scenario: show video
    When I am on the "video" page
    When I follow image link "Running Glacier Park in the Spring"
    Then I should see "Running Glacier Park in the Spring"
