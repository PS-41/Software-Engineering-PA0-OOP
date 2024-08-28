Feature: Create
  Join is not RESTful, so we need create

  Example: Format of request to create a person
    When I request "create username=\"alice\" password=\"wonderland\" name=\"Alice\" status=\"quite small\""
    Then I should see "[account created]"

  Example: Create a new person
    When I create a person with name "Alice" and username "alice" and password "wonderland" and status "quite small"
    Then I should see "[account created]"
    And I should see the show person page for "alice" with name "Alice" and status "quite small"
    And I should see "edit:"
    And I should see "update:"
    And I should see "delete:"
    And I should see "logout:"
    And I should see "<session>"

  Scenario Outline: Try to create a person with missing parameters
    When I request "create <params>"
    Then I should see "failed to create: <reason>"

    Examples:
      | params                                                    | reason              |
      |                                                           | missing username    |
      | username=\"alice\"                                        | missing password    |
      | password=\"wonderland\"                                   | missing username    |
      | name=\"Alice\"                                            | missing username    |
      | name=\"Alice\" username=\"alice\"                         | missing password    |
      | username=\"alice\" password=\"wonderland\"                | missing name        |
      | username=\"alice\" password=\"wonderland\" name=\"Alice\" | missing status      |
      | name=\"Alice\" username=\"alice\" password=\"wonderland\" | missing status      |

