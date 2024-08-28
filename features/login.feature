Feature: Login
  People can login to update their name and status.

  Scenario: Login with username that doesn't exist
    Given a person with username "alice1"
    When I login as "alice2" with password "password"
    Then I should see "access denied: incorrect username or password"
    And I should see "home: ./app"

  Scenario: Login with incorrect password
    Given a person with username "alice1" and password "password"
    When I login as "alice1" with password "drasspow"
    Then I should see "access denied: incorrect username or password"
    And I should see "home: ./app"

  Scenario: Login with no username or password
    When I login with no username or password
    Then I should see "invalid request: missing username and password"
    And I should see "home: ./app"

  Scenario: Login with no password
    Given a person with username "alice1"
    When I login as "alice1" with no password
    Then I should see "incorrect username or password"
    And I should see "home: ./app"

  Scenario: Login with correct username and password
    Given a person named "Alice" with username "alice1" and password "password" and status "i <3 bob"
    When I login as "alice1" with password "password"
    Then I should see "Welcome back to the App, Alice!"
    And I should see "i <3 bob"
    # only care about the first parts, trust that other features check the rest
    And I should see "edit:"
    And I should see "update:"
    And I should see "logout:"
    And I should see "people:"

  Scenario: Login twice
    # logging in twice should keep the same session token
    Given a person named "Alice" with username "alice1" and password "password" and status "i <3 bob"
    When I login as "alice1" with password "password"
    And I login as "alice1" with password "password" and get a new session token
    Then the new and old session tokens should be the same and non-empty

  Scenario: Login with complicated password
    Given a person with username "pcr" and password "#hacker's <\\3 ~2 m@ny $ecrets!"
    When I login as "pcr" with password "#hacker's <\\3 ~2 m@ny $ecrets!"
    Then I should see "Welcome back to the App, "
    # only care about the important parts, trust that other features check the rest
    And I should see "update:"
    And I should see "logout:"
    And I should see "logout:"
    And I should see "<session>"
