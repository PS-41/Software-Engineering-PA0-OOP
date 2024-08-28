Feature: Sessions
  Join or login to get a session token that can be used to authenticate future requests

  Scenario: Missing session token
    When I request "session"
    Then I should see "access denied: missing session token"

  Scenario Outline: Visit any page with an invalid session token
    When I visit the "<page>" page with an invalid session token
    Then I should see "invalid request: invalid session token"
    And I should see "home: ./app"

    Examples:
      | page   |
      | delete |
      | edit   |
      | find   |
      | home   |
      | join   |
      | login  |
      | logout |
      | people |
      | show x |
      | sort   |
      | update |

  Scenario: Visit the home page with valid session token
    Given I have the session token for a person named "George Carlin" with username "gcarl" and status "The status quo sucks."
    When I visit the home page with the session token
    Then I should see "Welcome back to the App, George Carlin!"
    And I should see "The status quo sucks."
    # <token> -> the session token
    And I should see "edit: ./app 'session <token> edit'"
    And I should see "update: ./app 'session <token> update (name=\"<value>\"|status=\"<value>\")+'"
    And I should see "logout: ./app 'session <token> logout'"
    And I should see "people: ./app '[session <token> ]people'"

  Scenario: Visit my person page with a valid session token
    Given I have the session token for a person named "George Carlin" with username "gcarl" and status "The status quo sucks."
    When I visit the show person page for "gcarl" with the session token
    Then I should see "Person"
    And I should see "name: George Carlin"
    And I should see "username: gcarl"
    And I should see "status: The status quo sucks."
    And I should see "updated: "
    And I should see "edit: ./app 'session <token> edit'"
    And I should see "update: ./app 'session <token> update (name=\"<value>\"|status=\"<value>\")+'"
    And I should see "delete: ./app 'session <token> delete'"
    And I should see "logout: ./app 'session <token> logout'"
    And I should see "people: ./app '[session <token> ]people'"
    And I should see "home: ./app ['session <token>']"

  Scenario: Visit show people page with a valid session token
    Given I have a valid session token
    When I visit the "people" page with the session token
    And I should see "find: ./app 'find <pattern>\'"
    And I should see "sort: ./app 'sort[ username|name|status|updated[ asc|desc]]'"
    And I should see "edit: ./app 'session <token> edit'"
    And I should see "update: ./app 'session <token> update (name=\"<value>\"|status=\"<value>\")+'"
    And I should see "home: ./app ['session <token>']"
