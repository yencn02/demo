Feature: Search video
  Any users can search videos

  Background:
    Given I have the following videos
      | title                    | description                                                                                                                                                  |
      | Pacific Northwest Hike   | This walking tour of coastal Oregon boasts one ocean, seven waterfalls, and sparkling blue Crater Lake.                                                      |
      | American Southwest Hike  | Witness the lonely majesty of Utah’s Delicate Arch and the epic expanse of Arizona’s Grand Canyon in this picturesque hike.                                  |
      | Pacific Northwest Run    | Jog down the Seattle waterfront, dodge farmers and fish mongers at Pike’s Place Market, and sprint the to finish in the shadow of volcanic Mount St. Helens. |
      | American Southwest Run   | Elegant natural arches, surreal hoodoos, and the Grand Canyon highlight this running tour of Arizona and Utah.                                               |
  @javascript
  Scenario: No results
    When I am on "the home page"
    And I fill in "search-query" with "test key"
    And I submit the search form
    Then I should see "No videos"
    And I should not see the below
      | text                     |
      | Pacific Northwest Hike   |
      | American Southwest Hike  |
      | Pacific Northwest Run    |
      | American Southwest Run   |

  @javascript
  Scenario: Search on title
    When I am on "the home page"
    And I fill in "search-query" with "Hike"
    And I submit the search form
    Then I should not see "No videos"
    And I should see below
      | text                                                                   |
      | Pacific Northwest Hike                                                 |
      | American Southwest Hike                                                |
      | This walking tour of coastal Oregon boasts one ocean, seven waterfalls |
      | Witness the lonely majesty of Utah’s Delicate Arch and the epic        |

  @javascript
  Scenario: Search on description
    When I am on "the home page"
    And I fill in "search-query" with "waterfront"
    And I submit the search form
    Then I should not see "No videos"
    And I should see below
      | text                                                           |
      | Pacific Northwest Run                                          |
      | Jog down the Seattle waterfront, dodge farmers and fish mongers|
    And I should not see the below
      | text                                                  |
      | American Southwest Hike                               |
      | This walking tour of coastal Oregon boasts one ocean, |
      | Witness the lonely majesty of Utah’s Delicate Arch    |
