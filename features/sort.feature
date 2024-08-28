Feature: Sorting People
  On the show people page, we can sort by name, status, and time.

  Background: The people on the app (takes about 4 seconds before each scenario)
    Given the following people have joined the app in this order:
      | username | password | name  | status                     |
      | zlice    | password | Alice | listening to bob           |
      | mob      | password | Bob   | talking to alice           |
      | eve      | password | Eve   | listening to alice and bob |
      | mrdave   | password | Dave  | zzz                        |

  Example: Default sort on show people is by updated descending
    When I visit the "show people" page
    Then I should see "Dave" before "Eve"
    And I should see "Eve" before "Bob"
    And I should see "Bob" before "Alice"

  Example: Default sort is by updated in descending
    When I request "sort"
    Then I should see "Dave" before "Eve"
    And I should see "Eve" before "Bob"
    And I should see "Bob" before "Alice"

  Example: Default sort order for username is ascending
    When I sort by "username"
    Then I should see "Eve" before "Bob"
    And I should see "Bob" before "Dave"
    And I should see "Dave" before "Alice"

  Example: Default sort order for name is ascending
    When I sort by "name"
    Then I should see "Alice" before "Bob"
    And I should see "Bob" before "Dave"
    And I should see "Dave" before "Eve"

  Example: Default sort order for status is ascending
    When I sort by "status"
    Then I should see "Eve" before "Alice"
    And I should see "Alice" before "Bob"
    And I should see "Bob" before "Dave"

  Example: Default sort order for updated is descending
    When I sort by "updated"
    Then I should see "Dave" before "Eve"
    And I should see "Eve" before "Bob"
    And I should see "Bob" before "Alice"

  Scenario: Sort by updated descending
    When I sort by "updated desc"
    Then I should see "Dave" before "Eve"
    And I should see "Eve" before "Bob"
    And I should see "Bob" before "Alice"

  Scenario: Sort by updated ascending
    When I sort by "updated asc"
    Then I should see "Alice" before "Bob"
    And I should see "Bob" before "Eve"
    And I should see "Eve" before "Dave"

  Scenario: Sort by username ascending
    When I sort by "username asc"
    Then I should see "Eve" before "Bob"
    And I should see "Bob" before "Dave"
    And I should see "Dave" before "Alice"

  Scenario: Sort by username descending
    When I sort by "username desc"
    Then I should see "Alice" before "Dave"
    And I should see "Dave" before "Bob"
    And I should see "Bob" before "Eve"

  Scenario: Sort by name ascending
    When I sort by "name asc"
    Then I should see "Alice" before "Bob"
    And I should see "Bob" before "Dave"
    And I should see "Dave" before "Eve"

  Scenario: Sort by name descending
    When I sort by "name desc"
    Then I should see "Eve" before "Dave"
    And I should see "Dave" before "Bob"
    And I should see "Bob" before "Alice"

  Scenario: Sort by status ascending
    When I sort by "status asc"
    Then I should see "Eve" before "Alice"
    And I should see "Alice" before "Bob"
    And I should see "Bob" before "Dave"

  Scenario: Sort by status descending
    When I sort by "status desc"
    Then I should see "Dave" before "Bob"
    And I should see "Bob" before "Alice"
    And I should see "Alice" before "Eve"
