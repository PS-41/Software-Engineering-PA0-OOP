Feature: Validation
  Validating data for join and create

  Rule: Usernames contain alphanumeric characters or underlines

    Scenario Outline: Try to register with a username that contains whitespace
      When I <register> with username "prof ritchey"
      Then I should see "failed to create: invalid username"

      Examples:
      | register        |
      | join            |
      | create a person |

    Scenario Outline: Valid usernames
      When I <register> with username "<username>"
      Then I should see "[account created]"
      And I should see "Person"
      And I should see "username: <username>"

      Examples:
        | register        | username     |
        | join            | pcr          |
        | join            | prof_ritchey |
        | join            | _____        |
        | join            | 8675309      |
        | join            | _a1ic3_      |
        | create a person | pcr          |
        | create a person | prof_ritchey |
        | create a person | _____        |
        | create a person | 8675309      |
        | create a person | _a1ic3_      |

    Scenario Outline: Try to register with a username that contains an illegal character
      When I <register> with username "<username>"
      Then I should see "failed to create: invalid username"

      Examples:
        | register        | username      |
        | join            | prof.ritchey  |
        | join            | @pcr          |
        | join            | (^-^)         |
        | join            | 13-0          |
        | join            | texas_a&m     |
        | create a person | prof ritchey  |
        | create a person | hansel+gretal |
        | create a person | ConanO'Brien  |
        | create a person | i<3u          |
        | create a person | !2%er         |

    Scenario Outline: Pipes in usernames are also illegal
      When I <register> with username "p|pe"
      Then I should see "failed to create: invalid username"

      Examples:
      | register        |
      | join            |
      | create a person |

    Scenario Outline: Double quotes in usernames are also illegal
      When I <register> with username "q\"ote"
      Then I should see "failed to create: invalid username"

      Examples:
      | register        |
      | join            |
      | create a person |

  Rule: Usernames must contain at least 3 but not more than 20 characters

    Scenario Outline: Usernames that are too short
      When I <register> with username "<username>"
      Then I should see "failed to create: username is too short"

      Examples:
        | register        | username |
        | join            |          |
        | join            | a        |
        | join            | aa       |
        | create a person |          |
        | create a person | a        |
        | create a person | aa       |

    Scenario Outline: A username with more than 20 characters is too long
      When I <register> with username "twenty_one_characters"
      Then I should see "failed to create: username is too long"

      Examples:
      | register        |
      | join            |
      | create a person |

  Rule: There can be only one (user with a given username)

    Scenario Outline: Username collisions
      Given a person with username "alice"
      When I <register> with username "alice"
      Then I should see "failed to create: alice is already registered"

      Examples:
      | register        |
      | join            |
      | create a person |

  Rule: Usernames are case-insensitive

    Scenario Outline: Username collisions ignore case
      Given a person with username "alice"
      When I <register> with username "<username>"
      Then I should see "failed to create: <username> is already registered"

      Examples:
      | register        | username |
      | join            | Alice    |
      | join            | ALICE    |
      | join            | aLiCe    |
      | create a person | Alice    |
      | create a person | ALICE    |
      | create a person | AlIcE    |

    Scenario Outline: Usernames get downcased
      When I <register> with username "<username>"
      Then I should see "[account created]"
      And I should see "Person"
      And I should see "username: <downcased>"

      Examples:
        | register        | username    | downcased   |
        | join            | PCR         | pcr         |
        | create a person | ProfRitchey | profritchey |

  Rule: Names, statuses, and passwords can contain any character except double quotes

    Scenario Outline: Double quotes not allowed in name, status, or password
      When I <register> with <attribute> "a \"quoted\" string"
      Then I should see "failed to create: <attribute> contains double quote"

      Examples:
      | register        | attribute |
      | join            | name      |
      | join            | status    |
      | join            | password  |
      | create a person | name      |
      | create a person | status    |
      | create a person | password  |

    Scenario Outline: A complicated but valid password
      When I <register> with username "pcr" and password "#hacker's <\\3 ~2 m@ny $ecrets!"
      Then I should see "[account created]"
      And I should see "username: pcr"
      And I should see "<session>"

      Examples:
      | register        |
      | join            |
      | create a person |

  Rule: Names must contain at least 1 but not more than 30 characters

    Scenario Outline: Names with invalid lengths
      When I <register> with name "<name>"
      Then I should see "failed to create: name is too <reason>"

      Examples:
      | register        | name                            | reason |
      | join            |                                 | short  |
      | join            | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | long   |
      | create a person |                                 | short  |
      | create a person | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | long   |


    Scenario Outline: Names with valid lengths
      When I <register> with name "<name>"
      Then I should see "[account created]"
      And I should see "name: <name>"

      Examples:
      | register        | name                           |
      | join            | a                              |
      | join            | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa |
      | create a person | a                              |
      | create a person | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa |

  Rule: Statuses must contain at least 1 but not more than 100 characters

    Scenario Outline: Statuses with invalid lengths
      When I <register> with status "<status>"
      Then I should see "failed to create: status is too <reason>"

      Examples:
      | register        | status | reason |
      | join            |        | short  |
      | create a person |        | short  |
      | join            | velit ut tortor pretium viverra suspendisse potenti nullam ac tortor vitae purus faucibus ornare susp | long   |
      | create a person | velit ut tortor pretium viverra suspendisse potenti nullam ac tortor vitae purus faucibus ornare susp | long   |


    Scenario Outline: Statuses with valid lengths
      When I <register> with status "<status>"
      Then I should see "[account created]"
      And I should see "status: <status>"

      Examples:
      | register        | status |
      | join            | .      |
      | create a person | .      |
      | join            | in iaculis nunc sed augue lacus viverra vitae congue eu consequat ac felis donec et odio pellentesqu |
      | create a person | in iaculis nunc sed augue lacus viverra vitae congue eu consequat ac felis donec et odio pellentesqu |

  Rule: Passwords must be at least 4 characters
    Scenario Outline: Passwords that are too short
      When I <register> with password "<password>"
      Then I should see "failed to create: password is too short"

      Examples:
        | register        | password |
        | join            |          |
        | join            | *        |
        | join            | **       |
        | join            | ***      |
        | create a person |          |
        | create a person | *        |
        | create a person | **       |
        | create a person | ***      |
