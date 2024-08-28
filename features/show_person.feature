Feature: Show Person
  Show info about a single person.

  Example: About a person
    Given a person named "Alice" with username "alice1" and status "i <3 bob"
    When I visit the show person page for "alice1"
    Then I should see "Person"
    And I should see "name: Alice"
    And I should see "username: alice1"
    And I should see "status: i <3 bob"
    And I should see "updated: "
    And I should see "people: ./app 'people'"
    And I should see "home: ./app"

  Scenario: Request a person that doesn't exist
    When I visit the show person page for "bob07"
    Then I should see "not found"
    And I should see "home: ./app"

  Scenario: Request no one
    When I visit the show person page for nobody
    Then I should see "invalid request: missing username"
    And I should see "home: ./app"

  Scenario: Visit someone else's person page with a valid session token
    Given a person named "Alice" with username "alice" and status "i <3 bob"
    And I have a valid session token
    When I visit the show person page for "alice" with the session token
    Then I should see "Person"
    And I should see "name: Alice"
    And I should see "username: alice"
    And I should see "status: i <3 bob"
    And I should see "people: ./app '[session <token> ]people'"
    And I should see "logout: ./app 'session <token> logout'"
    And I should see "home: ./app ['session <token>']"
    But I should not see "edit:"
    And I should not see "update:"
    And I should not see "delete:"
