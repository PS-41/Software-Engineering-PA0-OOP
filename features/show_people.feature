Feature: Show People
  View the list of people using the app.

  Example: Anonymous user, no people
    Given I am not logged in
    And no people have joined the app
    When I visit the "show people" page
    Then I should see "People"
    And I should see "No one is here..."
    And I should see "find: ./app 'find <pattern>'"
    And I should see "sort: ./app 'sort[ username|name|status|updated[ asc|desc]]'"
    And I should see "join: ./app 'join'"
    And I should see "create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'"
    And I should see "home: ./app"

  Example: Anonymous user, some people
    Given the following people:
      | username | password | name  | status                     |
      | alice    | password | Alice | talking to bob             |
      | bob      | password | Bob   | talking to alice           |
      | eve      | password | Eve   | listening to alice and bob |
    When I visit the "show people" page
    Then I should see "People"
    # <datetime> -> \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}
    And I should see the following status:
      | Alice @alice (./app 'show alice') |
      |   talking to bob                  |
      |   @ <datetime>                    |
    And I should see the following status:
      | Bob @bob (./app 'show bob') |
      |   talking to alice          |
      |   @ <datetime>              |
    And I should see the following status:
      | Eve @eve (./app 'show eve')  |
      |   listening to alice and bob |
      |   @ <datetime>               |
    And I should see "find: ./app 'find <pattern>'"
    And I should see "sort: ./app 'sort[ username|name|status|updated[ asc|desc]]'"
    And I should see "join: ./app 'join'"
    And I should see "create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'"
    And I should see "home: ./app"
