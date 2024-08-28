Feature: Update
  Edit is not RESTful, so we need update

  Example: Format of request to update a person
    Given I have the session token for a person named "Alice" with username "alice" and status "quite small"
    When I request "update name=\"Alice von W.\" status=\"chasing the white rabbit\"" with the session token
    Then I should see "[name and status updated]"
    And I should see "name: Alice von W."
    And I should see "status: chasing the white rabbit"
    And I should see "updated:"
    And I should see "edit:"
    And I should see "update:"
    And I should see "delete:"
    And I should see "<session>"

  Example: Update a person
    Given I have the session token for a person named "Alice" with username "alice" and status "quite small"
    When I update the person to have name "Alice von W." and status "chasing the white rabbit"
    Then I should see "[name and status updated]"
    And I should see "name: Alice von W."
    And I should see "status: chasing the white rabbit"
    And I should see "updated:"
    And I should see "edit:"
    And I should see "update:"
    And I should see "delete:"
    And I should see "logout:"
    And I should see "<session>"

  Example: Update a person's name
    Given I have the session token for a person named "Alice" with username "alice" and status "quite small"
    When I update the person to have name "Alice von W."
    Then I should see "[name updated]"
    And I should see "name: Alice von W."
    And I should see "status: quite small"
    And I should see "updated:"
    And I should see "edit:"
    And I should see "update:"
    And I should see "delete:"
    And I should see "<session>"

  Example: Update a person's name only, send same status
    Given I have the session token for a person named "Alice" with username "alice" and status "quite small"
    When I update the person to have name "Alice von W." and status "quite small"
    Then I should not see "[status updated]"
    And I should not see "[name and status updated]"
    But I should see "[name updated]"
    And I should see "name: Alice von W."
    And I should see "status: quite small"
    And I should see "updated:"
    And I should see "edit:"
    And I should see "update:"
    And I should see "delete:"
    And I should see "<session>"

  Example: Update a person's status
    Given I have the session token for a person named "Alice" with username "alice" and status "quite small"
    When I update the person to have status "chasing the white rabbit"
    Then I should see "[status updated]"
    And I should see "name: Alice"
    And I should see "status: chasing the white rabbit"
    And I should see "updated:"
    And I should see "edit:"
    And I should see "update:"
    And I should see "delete:"
    And I should see "<session>"

  Example: Update a person's status only, send same name
    Given I have the session token for a person named "Alice" with username "alice" and status "quite small"
    When I update the person to have name "Alice" and status "chasing the white rabbit"
    Then I should not see "[name updated]"
    And I should not see "[name and status updated]"
    But I should see "[status updated]"
    And I should see "name: Alice"
    And I should see "status: chasing the white rabbit"
    And I should see "updated:"
    And I should see "edit:"
    And I should see "update:"
    And I should see "delete:"
    And I should see "<session>"

  Example: Update nothing
    Given I have the session token for a person named "Alice" with username "alice" and status "quite small"
    When I update the person to have name "Alice" and status "quite small"
    Then I should not see "[name updated]"
    And I should not see "[status updated]"
    And I should not see "[name and status updated]"
    But I should see "name: Alice"
    And I should see "status: quite small"
    And I should see "updated:"
    And I should see "edit:"
    And I should see "update:"
    And I should see "delete:"
    And I should see "<session>"

  Example: Update without parameters
    Given I have the session token for a person named "Alice" with username "alice" and status "quite small"
    When I request update with no parameters
    Then I should not see "[name updated]"
    And I should not see "[status updated]"
    And I should not see "[name and status updated]"
    But I should see "failed to update: missing name and status"

  Scenario Outline: Try to update with invalid parameters
    Given I have a valid session token
    When I update the person to have name "<name>" and status "<status>"
    Then I should see "failed to update: <reason>"

    Examples:
      | name                            | status | reason              |
      |                                 |        | name is too short   |
      | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | a      | name is too long    |
      | a                               |        | status is too short |
      | a | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | status is too long |

  Scenario: Update without session token
    When I request update without a session token
    Then I should see "invalid request: missing session token"
