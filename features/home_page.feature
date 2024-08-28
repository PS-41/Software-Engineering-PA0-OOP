Feature: Home Page
  The home page greets the user and tells them what they can do.

  Scenario: Visit the home page
    Given I am not logged in
    When I visit the home page
    Then I should see "Welcome to the App!"
    And I should see "login: ./app 'login <username> <password>'"
    And I should see "join: ./app 'join'"
    And I should see "create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'"
    And I should see "people: ./app 'people'"

  Example: The home page is also the default page
    Given I am not logged in
    When I request nothing
    Then I should see "Welcome to the App!"
    And I should see "login: ./app 'login <username> <password>'"
    And I should see "join: ./app 'join'"
    And I should see "create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'"
    And I should see "people: ./app 'people'"
