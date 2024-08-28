Feature: Edit
  Change your name or status

  Example: Edit interface
    Given a person named "Andrew" with username "ender" and password "speaker" and status "pour one out"
    When I login as "ender" with password "speaker"
    And I edit my name to be "Ender" and my status to be "i miss valentine"
     # edit person form fields
    Then I should see "Edit Person"
    And I should see "leave blank to keep [current value]"
    And I should see "name [Andrew]: "
    And I should see "status [pour one out]: "
    # "flash" message for update
    And I should see "[name and status updated]"
    # show person page for ender
    And I should not see "name: Andrew"
    And I should not see "status: pour one out"
    But I should see "name: Ender"
    And I should see "status: i miss valentine"
    And I should see "updated:"
    And I should see "edit:"
    And I should see "delete:"
    And I should see "logout:"
    And I should see "<session>"

  Example: Change name only
    Given a person named "Peter" with username "locke" and password "hegemon" and status "i rule"
    When I login as "locke" with password "hegemon"
    And I take note of my last updated timestamp
    And I edit my name to be "Locke"
    Then I should see "[name updated]"
    And I should not see "name: Peter"
    But I should see "name: Locke"
    And I should see "status: i rule"
    And the timestamp should be updated

  Example: Change status only
    Given a person named "Valentine" with username "demosthenes" and password "ender" and status "blame russia"
    When I login as "demosthenes" with password "ender"
    And I take note of my last updated timestamp
    And I edit my status to be "compromise maybe?"
    Then I should see "[status updated]"
    And I should not see "status: blame russia"
    But I should see "name: Valentine"
    And I should see "status: compromise maybe?"
    And the timestamp should be updated

  Example: Change nothing
    Given a person named "Mazer Rackham" with username "mazer" and password "oldman" and status "i'll make a xenocide out of you"
    When I login as "mazer" with password "oldman"
    And I take note of my last updated timestamp
    And I go to edit but I don't change anything
    Then I should not see "[name updated]"
    And I should not see "[status updated]"
    And I should not see "[name and status updated]"
    But I should see "name: Mazer Rackham"
    And I should see "status: i'll make a xenocide out of you"
    And the timestamp should not be updated

  Scenario: Edit without session token
    When I request edit without a session token
    Then I should see "invalid request: missing session token"
