Feature: Rename a node

  Background:
    Given I open the application

  Scenario: Rename a page
    When I right click the node with path "./home.txt"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the input with "The new home" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "The new home"

    When I reload the application
    Then I should see the node titled "The new home"

    When I click the node with path "./The new home.txt"
    Then I should see "Sample page" within "h1"
    And I should see generated content for the node with path "./The new home.txt"

  Scenario: Rename a page to existing name
    When I right click the node with path "./home.txt"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the input with "test" within the dialog box
    And I press "OK" within the dialog box
    And I reload the application
    And I should see "home"
    And I should see "test"

    When I click the node with path "./home.txt"
    Then I should see "Sample page" within "h1"
    And I should see generated content for the node with path "./home.txt"

    When I click the node with path "./test.txt"
    Then I should see generated content for the node with path "./test.txt"
    And I should see page title "Rwiki ./test.txt"
    And I should have the following open tabs:
      | home |
      | test |

  Scenario: Rename a page when tab is open
    When I click the node with path "./test.txt"
    And I click the node with path "./home.txt"
    Then I should see page title "Rwiki ./home.txt"

    And I right click the node with path "./home.txt"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the input with "The new home" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "The new home"
    And I should have the following open tabs:
      | test         |
      | The new home |
    And I should see page title "Rwiki ./The new home.txt"
    And I should see generated content for the node with path "./The new home.txt"

  Scenario: Rename a folder
    When I expand the node with path "./folder"
    And I open the page for the tree node with path "./folder/test.txt"

    When I right click the node with path "./folder"
    And I follow "Rename node"
    Then I should see dialog box titled "Rename node"

    When I fill in the input with "The new folder name" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "The new folder name"
    Then I should see page title "Rwiki ./The new folder name/test.txt"
    And I open the page for the tree node with path "./The new folder name/test.txt"

    When I reload the application
    Then I should see the node titled "The new folder name"
    And I open the page for the tree node with path "./The new folder name/test.txt"
