Feature: Finding People
  Search for people that match a given pattern

  Background:
    Given the following people:
      | username | password | name  | status                     |
      | alice    | password | Alice | listening to bob           |
      | bob      | password | Bob   | talking to alice           |
      | eve      | password | Eve   | listening to alice and bob |
      | dave     | password | Dave  | zzz                        |
      | carol    | password | Carol | i'm like: to where?        |

  Example: Find with no argument should find all
    When I request "find"
    Then I should see "People (find all)"
    And I should see "Alice"
    And I should see "Bob"
    And I should see "Eve"
    And I should see "Dave"
    And I should see "Carol"

  Scenario Outline: Find parameters are displayed
      When I search for "<search>"
      Then I should see "People (find \"<value>\" in <field>)"

      Examples:
        | search           | value      | field    |
        | truth            | truth      | any      |
        | name: Alice      | Alice      | name     |
        | username: bob    | bob        | username |
        | status: z        | z          | status   |
        | updated: 2024-09 | 2024-09    | updated  |
        | fake: data       | fake: data | any      |

  Example: Find searches all fields by default
    When I search for "alice"
    # because her username is "alice"
    Then I should see "Alice"
    # because their statuses include "alice"
    And I should see "Bob"
    And I should see "Eve"
    # because none of his data includes "alice"
    But I should not see "Dave"

  Example: Find takes all remaining values in request
    When I search for "status: alice and bob"
    # because her status contains "alice and bob"
    Then I should see "Eve"
    # because theirs statuses do not
    But I should not see "Alice"
    And I should not see "Bob"
    And I should not see "Dave"

  Scenario: Search all fields for "listen"
    When I search for "listen"
    # because their statuses include it
    Then I should see "Alice"
    And I should see "Eve"
    # because their statuses don't, nor any other field
    But I should not see "Bob"
    And I should not see "Dave"

  Scenario: Find by username
    When I search for "username: alice"
    # because her username is "alice"
    Then I should see "Alice"
    # because their usernames do not include "alice"
    But I should not see "Bob"
    And I should not see "Eve"
    And I should not see "Dave"

  Scenario: Find by name
    When I search for "name: v"
    # because their names include "v"
    Then I should see "Eve"
    And I should see "Dave"
    # because their names do not include "v"
    But I should not see "Bob"
    And I should not see "Alice"

  Scenario: Find by status
    When I search for "status: alice"
    # because their statuses include "alice"
    Then I should see "Bob"
    And I should see "Eve"
    # because their statuses do not include "alice"
    But I should not see "Alice"
    And I should not see "Dave"

  Scenario: Find by updated
    # fixme: limited control over updated value -> assume year is 2024
    When I search for "updated: 2024"
    Then I should see "Alice"
    And I should see "Bob"
    And I should see "Eve"
    And I should see "Dave"

  Example: Find by fake attribute
    When I search for "like: to"
    Then I should see "Carol"
    But I should not see "Alice"
    And I should not see "Bob"
    And I should not see "Eve"
    And I should not see "Dave"

  Example: Find maintains session if present
    Given I have a valid session token
    When I request "find" with the session token
    Then I should see "People (find all)"
    And I should see "<session>"

  Scenario: Find finds nobody
    When I search for "aliens"
    Then I should see "People (find \"aliens\" in any)"
    And I should see "No one is here..."
