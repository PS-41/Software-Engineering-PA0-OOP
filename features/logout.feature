Feature: Logout
  People can logout when they are done.

  Scenario: Logout without a session token
    When I logout without a session token
    Then I should see "invalid request: missing session token"
    And I should see "home: ./app"

  Scenario: Logout with an invalid session token
    When I logout with an invalid session token
    Then I should see "invalid request: invalid session token"
    And I should see "home: ./app"

  Scenario: Logout with a valid session token
    Given I have a valid session token
    When I logout with the session token
    Then I should see "[you are now logged out]"
    And I should see "Welcome to the App!"
    And I should see "login: ./app 'login <username> <password>'"
    And I should see "join: ./app 'join'"
    And I should see "create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'"
    And I should see "people: ./app 'people'"

  Scenario: Logout with a valid session token and then try to use it
    # logging out should invalidate the token
    Given I have a valid session token
    When I logout with the session token
    And I visit the home page with the session token
    Then I should see "invalid request: invalid session token"
    And I should see "home: ./app"
