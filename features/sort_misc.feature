Feature: Sort Misc.
  Things like how sort handles invalid requests and what the page should look like.

  Background:
    Given the following people:
      | username | password | name  | status                     |
      | alice    | password | Alice | listening to bob           |
      | bob      | password | Bob   | talking to alice           |
      | eve      | password | Eve   | listening to alice and bob |
      | dave     | password | Dave  | zzz                        |

  Scenario: Sort by fake attribute
      When I sort by "password asc"
      Then I should see "not found"

    Scenario: Fake sort order
      When I sort by "username bogo"
      Then I should see "not found"

    Scenario Outline: Sort attribute and order are displayed
      When I sort by "<sort>"
      Then I should see "People (sorted by <print>)"

      Examples:
        | sort          | print           |
        |               | updated, newest |
        | username      | username, a-z   |
        | name          | name, a-z       |
        | status        | status, a-z     |
        | updated       | updated, newest |
        | username desc | username, z-a   |
        | name desc     | name, z-a       |
        | status desc   | status, z-a     |
        | updated asc   | updated, oldest |
