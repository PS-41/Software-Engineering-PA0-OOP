Feature: Delete
  Don't  be a part of any club that would have you as a member.

  Background: Some people in the app
    Given the following people:
      | username | password | name  | status                     |
      | alice    | hearts   | Alice | talking to bob             |
      | bob      | epsilon  | Bob   | talking to alice           |
      | eve      | seven    | Eve   | listening to alice and bob |

  Example: Deleting your account shows the home page
    When I login as "alice" with password "hearts"
    And I delete my account
    Then I should see "[account deleted]"
    And I should see "Welcome to the App!"
    And I should see "login: ./app 'login <username> <password>'"
    And I should see "join: ./app 'join'"
    And I should see "create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'"
    And I should see "people: ./app 'people'"

  Example: Deleting your account removes you from the list of people
    When I login as "alice" with password "hearts"
    And I delete my account
    And I visit the "show people" page
    Then I should see "Bob"
    And I should see "Eve"
    But I should not see "Alice"

  Scenario: Try to login to a deleted account
    When I login as "eve" with password "seven"
    And I delete my account
    And I login as "eve" with password "seven"
    Then I should see "access denied: incorrect username or password"

  Scenario: Try to use the session token for a deleted account
    When I login as "bob" with password "epsilon"
    And I delete my account
    And I visit the home page with the session token
    Then I should see "invalid request: invalid session token"

  Scenario: Delete without session token
    When I request delete without a session token
    Then I should see "invalid request: missing session token"
