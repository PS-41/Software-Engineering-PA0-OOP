Feature: Join
  Join the app / service.

  Example: New person interface
    When a person named "Alice von W." joins with username "alice1" and password "whiterabbit" and status "falling..."
    # new person form fields
    Then I should see "New Person"
    And I should see "username: "
    And I should see "password: "
    And I should see "confirm password: "
    And I should see "name: "
    And I should see "status: "
    # "flash" message for new account
    And I should see "[account created]"
    # show person page for alice1
    And I should see "Person"
    And I should see "name: Alice von W."
    And I should see "username: alice1"
    And I should see "status: falling..."
    And I should see "updated: "
    # links to more resources
    And I should see "edit: ./app '<session> edit'"
    And I should see "delete: ./app '<session> delete'"
    And I should see "logout: ./app '<session> logout'"
    And I should see "people: ./app '\[<session> \]people'"
    And I should see "home: ./app \['<session>'\]"

  Rule: Password and confirmation of password must match

    Scenario: Mismatched passwords
      When a person named "Robert Gates" joins with username "ranger65" and password1 "duty" and password2 "dooty" and status "leaders gonna lead"
      Then I should see "failed to join: passwords do not match"
      And I should see "home: ./app"