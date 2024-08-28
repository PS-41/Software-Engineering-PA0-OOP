Feature: Resource Not Found
  What happens when the user requests a resource which doesn't exist.

  Scenario: Invalid actions
    When I request "forget that"
    Then I should see "not found"
    And I should see "home: ./app"
