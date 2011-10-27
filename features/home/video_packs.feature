Feature: Show the feature video pack
  should show the feature video in home page

  Background:
    Given I have the following the videos pack
      | video_pack_name | is_featured |
      | Running         | 1           |
      | Hiking          | 0           |
      | Cycling         | 1           |
      | Touring         | 0           |

  Scenario: see list video is feature
    When I am on the "the home page"
    Then I should see "Running"
    Then I should see "Cycling"

  Scenario: don't show list video pack isn't feature
    When I am on the "the home page"
    Then I should not see "Hiking"
    Then I should not see "Touring"
