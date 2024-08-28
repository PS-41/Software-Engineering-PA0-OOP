Feature: One at a Time
  Resources should only be requested one at a time.
  Ignore all resources after the first.

  Scenario: Request people and show person
    When I request "people show alice1"
    # I should be on the show people page
    Then I should see "People"
    And I should see "No one is here..."
    And I should see "find: ./app 'find <pattern>'"
    And I should see "sort: ./app 'sort[ username|name|status|updated[ asc|desc]]'"
    And I should see "join: ./app 'join'"
    And I should see "create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'"

  Scenario: Request show person and people
    Given a person named "Alice" with username "alice1" and status "i <3 bob"
    When I request "show alice1 people"
    # I should be on the "show alice1" page
    Then I should see "Person"
    And I should see "name: Alice"
    And I should see "username: alice1"
    And I should see "status: i <3 bob"
    And I should see "updated: "
    And I should see "people: ./app 'people'"
    And I should see "home: ./app"
